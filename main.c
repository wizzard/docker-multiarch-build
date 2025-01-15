#include <stdio.h>
#include <sys/utsname.h>

int main() {
    struct utsname sys_info;

    if (uname(&sys_info) == 0) {
        printf("CPU Architecture: \033[0;31m%s\033[0m\n", sys_info.machine);
    } else {
        perror("uname");
    }

    return 0;
}