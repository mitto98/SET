#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv) {
    
    char* string, *string2;
    pid_t child;
    int child_return_status;

    string = (char*) malloc(101 * sizeof(char));
    string2 = (char*) malloc(106 * sizeof(char));

    while(1) {
        printf("nano-shell $");
        printf(" inserire un nome di file:\n");
        if (fgets(string, 100, stdin) == NULL || strcmp(string, "exit") == 0)
            exit(EXIT_SUCCESS);

        string[strlen(string)-1] = 0;

        strcpy(string2, "/bin/");
        strcat(string2, string);

        child = fork();
        if (0 == child) {
            execl(string2, "", NULL);
            perror(string2);

            strcpy(string2, "/usr/bin/");
            strcat(string2, string);
            execl(string2, "", NULL);
            perror(string2);
        }

        wait(&child_return_status);
    }


    exit(0);
}