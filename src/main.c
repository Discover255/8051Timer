#include <reg52.h>
sbit dula = P1^6;
sbit wela = P1^7;
int main() {
	while (1) {
		dula=1;
		P1=0x00;
		dula=0;
		wela=1;
		P2 = ~0xC0;
		wela=0;			
	}
}