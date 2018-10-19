#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv) {
    pid_t child;
    int child_return_status;
    int new_stdout;

    if (argc < 2) {
        fputs("Not enough arguments\n", stderr);
        exit(1);
    }

    child = fork();
    if (0 == child) {
        close(STDOUT_FILENO);
        new_stdout = open(argv[1], O_WRONLY);
        dup2(new_stdout, STDOUT_FILENO);
        if (-1 == execl("/bin/ls", "/bin/ls", "-l", NULL))
            exit(-1);
    }
    
    wait(&child_return_status);

    exit(0);
}