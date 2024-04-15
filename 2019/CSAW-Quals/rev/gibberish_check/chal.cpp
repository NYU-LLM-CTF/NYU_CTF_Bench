#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <signal.h>
#include <sys/ptrace.h>
#include <algorithm>
using namespace std;

char ascii[27] = {'_','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

int string_score(string given, string input){
  int n = given.size();
  int m = input.size();
  int cost;
  vector<vector<int>> score(m+1, vector<int>(n+1, 0));
  vector<char> given_string;
  vector<char> input_string;

  if(n == 0 || m == 0){
    return 0;
  }

  for (int i = 1; i < n+1; i++){
    given_string.push_back(given[i-1]);
    score[0][i] = i;
  }

  for (int i = 1; i  < m+1; i++){
    input_string.push_back(input[i-1]);
    score[i][0] = i;
  }

  given_string.insert(given_string.begin(), '\0');
  input_string.insert(input_string.begin(), '\0');

  for (int r = 1; r < m + 1; r++){
    for (int c = 1; c < n + 1; c++){
      if (given_string[r] == input_string[c]){
        cost = 0;
      }
      else{
        cost = 1;
      }
      score[r][c] = min(min((score[r-1][c-1] + cost), (score[r-1][c]+1)), (score[r][c-1]+1));
    }
  }
   return score[m][n];
}

void correct(){
  cout << "Correct!" << endl;
}

void wrong(){
  cout << "Wrong D:" << endl;
}

void *antidebug_func()
{
    uint8_t offset = 0;
    if (ptrace(PTRACE_TRACEME, 0, 1, 0) == 0) {
        offset = 2;
    }
    if (ptrace(PTRACE_TRACEME, 0, 1, 0) == -1) {
        offset *= 3;
    }
    if (offset != 6) {
        exit(1);
    }
}

void get_flag(){
  string line;
  ifstream flag ("flag.txt");
  if (flag.is_open()){
    while(getline (flag, line)){
      cout << line << endl;
    }
    flag.close();
  }
}

int main(){
  // antidebug_func();
  vector<string> keys = {"dqzkenxmpsdoe_qkihmd","jffglzbo_zghqpnqqfjs","kdwx_vl_rnesamuxugap","ozntzohegxagreedxukr","xujaowgbjjhydjmmtapo","pwbzgymqvpmznoanomzx","qaqhrjofhfiuyt_okwxn","a_anqkczwbydtdwwbjwi","zoljafyuxinnvkxsskdu","irdlddjjokwtpbrrr_yj","cecckcvaltzejskg_qrc","vlpwstrhtcpxxnbbcbhv","spirysagnyujbqfhldsk","bcyqbikpuhlwordznpth","_xkiiusddvvicipuzyna","wsxyupdsqatrkzgawzbt","ybg_wmftbdcvlhhidril","ryvmngilaqkbsyojgify","mvefjqtxzmxf_vcyhelf","hjhofxwrk_rpwli_mxv_","enupmannieqqzcyevs_w","uhmvvb_cfgjkggjpavub","gktdphqiswomuwzvjtog","lgoehepwclbaifvtfoeq","nm_uxrukmof_fxsfpcqz","ttsbclzyyuslmutcylcm"};

  cout << "Find the Key!" << endl;
  string input;
  int ans = 0;
  cin >> input;
//  cout << "Your input was: " << input << endl;

  for (auto vec: keys){
    ans += string_score(vec, input);
  }

//  cout << "Correct Score: " << ans << endl;

  if(((*(volatile unsigned*)string_score) & 0xFF) == 0xCC){
    printf("Rip\n");
    exit(1);
  }

//  cout << "your score is: " << ans << endl;

  if(ans == 505){
    correct();
    get_flag();
  }
  else{
    wrong();
  }
}
