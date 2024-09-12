#include <iostream>
#include <fstream>
#include <cstring>
#include <unistd.h>
using namespace std;

char buf[32];
int main(){
    string input;
    cout << "Tell me what you know about *nix philosophies: ";
    cin >> input;
    int secret = 0;
    for (int i = 1; i < input.size(); i++){
        string st{input[i]};
        for (char letter : st){secret += int(letter);}
    }
    int length = read(secret-0x643, buf, 32);
    if (!strcmp("make every program a filter\n",buf)){
        ifstream file("flag.txt");
        if (file.good()){
            cout << endl << "Welcome to pwning ^_^" << endl;
            system("/bin/cat flag.txt");
        } else{
            cout << endl << "flag.txt: No such file or directory" << endl;
            cout << "If you're running this locally, then running it on the remote server should give you the flag!" << endl;
        }
    } else{
        cout << "You still lack knowledge about *nix sorry" << endl;
    }
    return 0;
}
