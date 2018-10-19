#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char** argv) {
    pid_t child, child2;
    int child_return_status, child2_return_status;
    int piped_std[2];

    pipe(piped_std);

    child = fork();
    if (0 == child) {
        close(STDOUT_FILENO);        
        dup2(piped_std[1], STDOUT_FILENO);
        if (-1 == execl("/bin/ps", "/bin/ps", "aux", NULL))
            exit(-1);
    }

    child2 = fork();
    if (0 == child2) {
        close(STDIN_FILENO);
        dup2(piped_std[0], STDIN_FILENO);
        if (-1 == execl("/bin/grep", "/bin/grep", "bash", NULL))
            exit(-2);
    }
    
    wait(&child_return_status);
    wait(&child2_return_status);

    exit(0);
}