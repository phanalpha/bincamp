#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <sys/stat.h>

int main()
{
    struct passwd *passwd = getpwuid(getuid());
    struct stat st = { 0 };
    char trash[255];

    int n = snprintf(trash, sizeof trash, "%s/.Trash", passwd->pw_dir);
    if (sizeof trash <= n) {
	fprintf(stderr, "TL;\n");

	return EXIT_FAILURE;
    }

    if (n < 0 || stat(trash, &st) < 0)
	goto err;
    if (st.st_mode & S_IFDIR)
	return EXIT_SUCCESS;

    if (unlink(trash) < 0)
	goto err;

    return EXIT_SUCCESS;

  err:
    perror(NULL);

    return EXIT_FAILURE;
}
