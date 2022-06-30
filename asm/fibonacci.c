#include <stdio.h>

int main() {
  int a = 0;
  int a_1 = 1, a_2 = 1;
  a = a_1 + a_2;
  for (int i = 0; i < 40; i++) {
    a_2 = a_1;
    a_1 = a;
    a = a_1 + a_2;
  }

  return 0;
}
