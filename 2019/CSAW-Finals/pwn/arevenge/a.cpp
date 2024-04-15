// 1.5-range algorithms in C++ assume equal length -- if you can control the
// first range you can iteratively expose the second ranges values!!! (so
// std::equal(user_input.begin(), user_input.end(), secret_data.begin()) is
// vuln)

#include <iostream>
#include <string>
#include <vector>

using std::cin;
using std::cout;
using std::endl;

std::vector<uint8_t> get(size_t n) {
  std::vector<uint8_t> s(n, '\0');
  char c;
  for (size_t i = 0; i < n; i++) {
    cin >> c;
    s[i] = c;
  }
  return s;
}

template <typename T> void A(T secret) {
  size_t size;

  cin >> size;
  std::vector<uint8_t> data = get(size);

  bool eq = std::equal(data.begin(), data.end(), secret);
  if (eq) {
    cout << "You found a secret!" << endl;
  } else {
    cout << "You didn't find a secret :(" << endl;
  }
}

template <typename T> void B(T secret) {
  size_t size;
  cin >> size;

  std::vector<uint8_t> data = get(size);

  std::copy(data.begin(), data.end(), secret);
}

int go() {
  uint8_t secret[] = {0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe, 0xba, 0xbe};
  int choice;

  while (true) {
    cin >> choice;

    switch (choice) {
    case 1: // leak
      A(std::begin(secret));
      break;
    case 2: // write
      B(std::begin(secret));
      break;
    case 5: // exit
    default:
      cout << "ok, byebye!" << endl;
      return 0;
    }
  }
}

int main() {
  char buf[] = {0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa};
  go();
}
