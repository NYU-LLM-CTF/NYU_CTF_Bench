#include <vector>
#include <string>
#include <map>
#include <utility>
#include <set>
#include <time.h>
#include <stdlib.h>

using namespace std;

class Markov {
 public:
  map<pair<string, string>, vector<string> > pairs;
  set<string> known_words;

  Markov() {
    srand(time(NULL));
  }

  void do_set(vector<string> tokens) {
    int numstr = tokens.size();
    for (int ii = 0; ii < numstr; ++ii) {
      known_words.insert(tokens[ii]);
    }
  }
  void ingest(vector<string> tokens) {
    printvector(tokens);
    do_set(tokens);
    int numstr = tokens.size();
    if (numstr < 3) {
      return;
    }
    for (int ii = 0; ii < tokens.size() - 2; ++ii) {
      string tok1 = tokens[ii];
      string tok2 = tokens[ii + 1];
      string tok3 = tokens[ii + 2];
      pair<string, string> fromtok(tok1, tok2);
      map<pair<string, string>, vector<string> >::iterator it =
          pairs.find(fromtok);
      if (it != pairs.end()) {
        pairs[fromtok].push_back(tok3);
      } else {
        vector<string> newvec;
        newvec.push_back(tok3);
        pairs[fromtok] = newvec;
      }
    }
  }
  void printvector(vector<string> vs) {
    for (int ii =0; ii < vs.size(); ++ii) {
    }
  }
  string respond(string s1, string s2) {
    int maxwords = 64;
    string response = s1 + " " + s2;
    while (maxwords != 0) {
      pair<string, string> words(s1, s2);
      map<pair<string, string>, vector<string> >::iterator it =
          pairs.find(words);
      if (it != pairs.end()) {
        vector<string> responses = it->second;
        int randIndex = rand() % responses.size();
        response = response + " " + responses[randIndex];
        s1 = s2;
        s2 = responses[randIndex];
      } else {
        break;
      }
      --maxwords;
    }
    return response + "\n";
  }
};
