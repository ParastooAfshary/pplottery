// init: The initial user-level program

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/spinlock.h"
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"
#include "kernel/fcntl.h"


char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  // 🟢 Ask user to choose scheduler
  char buf[16];
  printf("Which scheduler do you want to use? [RR / Lottery]: ");
  read(0, buf, sizeof(buf));

  if (strncmp(buf, "Lottery", 7) == 0 || strncmp(buf, "lottery", 7) == 0) {
    setsched(1);  // Use Lottery scheduler
  } else {
    setsched(0);  // Use Round-Robin (default)
  }

  for(;;){
    printf("init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
      exec("sh", argv);
      printf("init: exec sh failed\n");
      exit(1);
    }

    for(;;){
      wpid = wait((int *) 0);
      if(wpid == pid){
        break;
      } else if(wpid < 0){
        printf("init: wait returned an error\n");
        exit(1);
      }
    }
  }
}

