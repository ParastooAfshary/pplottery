#include "kernel/types.h"
#include "user/user.h"

#define RUN_TIME 100000000

void cpu_bound_task(int id, int tickets) {
    settickets(tickets);

    int i;
    for (i = 0; i < RUN_TIME; i++) {
        if (i % 10000000 == 0) {
            printf("[proc %d, tickets %d] progress: %d\n", id, tickets, i);
        }
    }

    printf("[proc %d, tickets %d] DONE\n", id, tickets);
    exit(0);
}

int main(int argc, char *argv[]) {
    int tickets[3] = {10, 30, 90};

    printf("Starting lottery scheduling test...\n");

    for (int i = 0; i < 3; i++) {
        int pid = fork();
        if (pid == 0) {
            cpu_bound_task(i + 1, tickets[i]);
        }
    }

    for (int i = 0; i < 3; i++) {
        wait(0);
    }

    printf("Lottery scheduling test finished.\n");
    exit(0);
}
