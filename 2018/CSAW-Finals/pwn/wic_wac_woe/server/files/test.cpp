#include <emscripten.h>
#include <stdio.h>
#include <string>
#include <stdlib.h>


using namespace std;

EM_JS(void, check_flag, (const char* url, const char* flag), {
    game_over();
    let flag_ = Module.Pointer_stringify(flag);
    let url_ = Module.Pointer_stringify(url);
    fetch(url_, {
        method: 'POST',
        body: flag_,
        mode: 'cors',
        credentials: 'include'
    }).then(r=>r.json()).then(j => {
        if (j.good) {
            document.body.className="win";
            document.getElementById("gameover").innerHTML = flag_;
        } else {
            document.body.className="lose";
            document.getElementById("gameover").innerHTML = 'You are not the admin...';
        }
    }).catch(x=>{
        document.body.className="lose";
        document.getElementById("gameover").innerHTML = 'Could not validate flag';
    });
});

EM_JS(void, lose_game, (), {
    game_over();
    document.body.className="lose";
    document.getElementById("gameover").innerHTML = 'AI WINS';
});

class FlagManager {
    public:
    FlagManager() {};
    FlagManager(string s0, string s1) : server(s0), flag1(s1), plays(0) {};
    virtual void validate_flag();

    string flag1;
    protected:
    string server;

    private:
    int plays;

};

class AuthorizedFlagManager: public FlagManager {
    public:
    AuthorizedFlagManager(string s0, string s1) : FlagManager(s0, s1) {};
    void validate_flag();
};

class UnauthorizedFlagManager: public FlagManager {
    public:
    UnauthorizedFlagManager(string s0, string s1) : FlagManager(s0, s1) {};
    void validate_flag();
};

void FlagManager::validate_flag() {
    printf("Not implemented\n");
}

void AuthorizedFlagManager::validate_flag() {
    check_flag(server.c_str(), flag1.c_str());
}

void UnauthorizedFlagManager::validate_flag() {
    check_flag(server.c_str(), "[REDACTED]");
}

char board[3][3] = {
    {0,0,0},
    {0,0,0},
    {0,0,0}};

bool game_over;

FlagManager* manager;

void ai_wins() {
    printf("Game over! AI wins!\n");
    game_over = true;
    lose_game();
    delete manager;
}

bool check_row(int r1, int c1, int r2, int c2, int r3, int c3) {
    char a = board[r1][c1];
    char b = board[r2][c2];
    char c = board[r3][c3];

    if (a == 1 && a == b && b == c) {
        printf("Game over! Player wins!\n");
        game_over = true;
        manager->validate_flag();
        return true;
    }
    return false;
}

void check_board() {
    if (check_row(0,0, 0,1, 0,1)) return;
    if (check_row(1,0, 1,1, 1,2)) return;
    if (check_row(2,0, 2,1, 2,2)) return;

    if (check_row(0,0, 1,0, 2,0)) return;
    if (check_row(0,1, 1,1, 2,1)) return;
    if (check_row(0,2, 1,2, 2,2)) return;

    if (check_row(0,0, 1,1, 2,2)) return;
    if (check_row(0,2, 1,1, 2,0)) return;
}

void place(int r, int c, int p) {
    char buff[100];
    board[r][c] = p;
    snprintf(buff, 100, "place_move(%u, %u, %u)", r, c, p);
    emscripten_run_script(buff);
}

bool ai_check(int r1, int c1, int r2, int c2, int r3, int c3, int p) {
    char a = board[r1][c1];
    char b = board[r2][c2];
    char c = board[r3][c3];

    if (a == b && a == p && c == 0) {
        place(r3, c3, 2);
        if (a == 2) ai_wins();
        return true;
    }
    if (a == c && a == p && b == 0) {
        place(r2, c2, 2);
        if (a == 2) ai_wins();
        return true;
    }
    if (b == c && b == p && a == 0) {
        place(r1, c1, 2);
        if (b == 2) ai_wins();
        return true;
    }
    return false;
}

void ai_move() {
    printf("Thinking\n");
    if (ai_check(0,0, 0,1, 0,2, 2)) return;
    if (ai_check(1,0, 1,1, 1,2, 2)) return;
    if (ai_check(2,0, 2,1, 2,2, 2)) return;

    if (ai_check(0,0, 1,0, 2,0, 2)) return;
    if (ai_check(0,1, 1,1, 2,1, 2)) return;
    if (ai_check(0,2, 1,2, 2,2, 2)) return;

    if (ai_check(0,0, 1,1, 2,2, 2)) return;
    if (ai_check(0,2, 1,1, 2,0, 2)) return;

    printf("No winning moves\n");

    if (ai_check(0,0, 0,1, 0,2, 1)) return;
    if (ai_check(1,0, 1,1, 1,2, 1)) return;
    if (ai_check(2,0, 2,1, 2,2, 1)) return;

    if (ai_check(0,0, 1,0, 2,0, 1)) return;
    if (ai_check(0,1, 1,1, 2,1, 1)) return;
    if (ai_check(0,2, 1,2, 2,2, 1)) return;

    if (ai_check(0,0, 1,1, 2,2, 1)) return;
    if (ai_check(0,2, 1,1, 2,0, 1)) return;
    printf("No blocking moves\n");

    for (int i = 0; i<3; i++) {
        for (int j = 0; j<3; j++) {
            if (board[i][j] == 0) {
                place(i,j, 2);
                return;
            }
        }
    }
}

string* username;

extern "C" {

    void init_app(char* server, char* flag) {
        char* target = "/check_flag";
        if (!strcmp(target, server)) {
            manager = new AuthorizedFlagManager(server, flag);
        } else {
            manager = new UnauthorizedFlagManager(server, flag);
        }
    }

    bool play_game(char* data) {
        char* comma = strchr(data,',');
        if (!comma)
            return false;
        *comma = '\0';
        unsigned int row = atoi(data);
        unsigned int col = atoi(comma+1);

        if (row >= 3 || col >= 3)
            return false;

        if (board[row][col] == 2)
            return false;
        
        printf("Placing %u %u\n",row,col);

        place(row, col, 1);
        check_board();

        ai_move();
        return true;
    }

    void set_username(char* name) {
        *username = name;
    }
}

int main() {
    printf("Starting Game!\n");
    manager = NULL;
    game_over = false;
    username = new string();
}



