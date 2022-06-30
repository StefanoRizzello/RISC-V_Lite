int main() {
  int a = 231;
  int b = 112;
  int srai = 0;
  int add = 0;
  int exor = 0;
  int andi = 0;

  srai = a >> 4;
  if (srai<b){
    a+=500;
  }
  andi = a & 0x304;
  exor = a ^ b;
  add = andi + exor;
  return 0;
}