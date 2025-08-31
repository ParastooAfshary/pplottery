#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2){
    printf("Usage: settickets <num>\n");
    exit(1);
  }

  settickets(atoi(argv[1]));
  exit(0);
}
