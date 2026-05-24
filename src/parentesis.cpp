#include <iostream>
#include <stack>

using namespace std;

// Comprova si entrada ben parentitzada
int main() {
  char c;
  //int parentesis = 0;
  stack <char> pila;
  pila.push('Z');
  bool be = true;
  int fila = 1;
  string linia;
  int columna = 0;
  bool string = false;
  //istringstream input;
  while (fila < 700 and be) {
    getline(cin, linia);
    int nChars = linia.length();
    //cout << "fila: " << fila << " te " << nChars << " cols" << endl;;
    for (columna = 1; columna <= nChars and be; columna++) {
      c = linia[columna - 1];
      if (c == '(' or c == '[') {
        //cout << c;
        pila.push(c);
      } else if  (c == ')') {
        //cout << c;
        be = pila.top() == '(';
        pila.pop();
      } else if  (c == ']') {
        //cout << c;
        be = pila.top() == '[';
        pila.pop();
      } else if (c == '"') {
        //cout << c;
        if (string) {
          be = pila.top() == '"';
          pila.pop();
          string = false;
        } else {
          pila.push(c);
          string = true;
        }
      }
    }
    //cout << endl;
    fila++;
  }
  if (be) {
    cout << "Tot pec" << endl;
  } else {
    cout << "Error a " << fila - 1 << ':' << columna << " amb " << c << endl;
    cout << "i " << pila.top() << endl;
  }
}
