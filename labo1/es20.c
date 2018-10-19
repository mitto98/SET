#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv) {

    pid_t child = fork();
    int status;

    if (0 == child) {
        execl("/bin/ls", "/bin/ls", "--color=auto", "-l", NULL);
    }

    wait(&status);

    exit(0);
}