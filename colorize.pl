#! /usr/bin/env perl

use Getopt::Long qw/HelpMessage/;
use Term::ANSIScreen;

my @grays = ( 7016, # Could not find a declaration file for module '...'.
	    );
my @excludes = ( 'node_modules/',
	       );
GetOptions( "gray=i" => \@grays,
	    "exclude=s" => \@excludes,
	    "help" => sub { HelpMessage( -verbose => 1 ) },
	  ) or die;

my $console = Term::ANSIScreen->new;
while (<>) {
  if (/file change detected. starting incremental compilation.../i) {
    $console->cls;
  }

  if (/: error TS(\d+)/) {
    my ($file, $code, $desc) = split /: /, $_, 3;
    if (grep { $_ == $1 } @grays or grep { $file =~ /$_/ } @excludes) {
      print color('bold black');
      print;
    } else {
      print color('reset');
      print colored("$file: ", 'green');
      print colored("$code: ", 'red');
      print $desc;
    }
  } else {
    print;
  }
}

__END__

=head1 NAME

colorize.pl - colorize tsc

=head1 SYNOPSIS

colorize.pl [B<--gray>=error-code...] [B<--exclude>=pattern...]

=head1 OPTIONS

=over 4

=item B<--help>

Print (on the standand output) a description of the command-line options.

=item B<--gray>

Add the error I<error-code> to the list of errors to be grayed.

=item B<--exclude>

Add the pattern I<pattern> to the list of patterns to be grayed.

=back
