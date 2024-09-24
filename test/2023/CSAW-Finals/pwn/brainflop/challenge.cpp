// clang++ -std=c++17 -O0 -g -Werror -fvisibility=hidden -flto
// -fsanitize=cfi-mfcall challenge.cpp -lsqlite3

#include <climits>
#include <ctime>
#include <iostream>
#include <limits>
#include <list>
#include <map>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

#include <sqlite3.h>

#define LOOP_DEPTH_MAX 50

static const char *db_path = "actual.db";
static const char *sql_select = "SELECT TIMESTAMP, TAPESTATE FROM brainflop;";
static const char *sql_insert =
    "INSERT INTO brainflop (TASKID, TIMESTAMP, TAPESTATE) VALUES(?, ?, ?);";

bool parseYesOrNo(const std::string &message);
std::optional<int> parseNumericInput(void);

class BFTask {
public:
  BFTask(int id, unsigned short tapeSize, bool doBackup)
      : _id(id), tape(tapeSize, 0), sql_query(sql_select),
        instructionPointer(0), dataPointer(0), doBackup(doBackup) {}

  ~BFTask() {
    if (doBackup)
      performBackup();

    tape.clear();
    if (_sqlite3ErrMsg)
      sqlite3_free(_sqlite3ErrMsg);
    if (db)
      sqlite3_close(db);
  }

  void run(const std::string &program, bool deletePreviousState) {
    if (deletePreviousState) {
      tape.clear();
      loopStack.clear();
      instructionPointer = 0;
      dataPointer = 0;
    }

    while (instructionPointer < program.length()) {
      char command = program[instructionPointer];
      switch (command) {
      case '>':
        incrementDataPointer();
        break;
      case '<':
        decrementDataPointer();
        break;
      case '+':
        incrementCellValue();
        break;
      case '-':
        decrementCellValue();
        break;
      case '.':
        outputCellValue();
        break;
      case ',':
        inputCellValue();
        break;
      case '[':
        if (getCellValue() == 0) {
          size_t loopDepth = 1;
          while (loopDepth > 0) {
            if (loopDepth == LOOP_DEPTH_MAX)
              throw std::runtime_error("nested loop depth exceeded.");

            instructionPointer++;
            if (program[instructionPointer] == '[') {
              loopDepth++;
            } else if (program[instructionPointer] == ']') {
              loopDepth--;
            }
          }
        } else {
          loopStack.push_back(instructionPointer);
        }
        break;
      case ']':
        if (getCellValue() != 0) {
          instructionPointer = loopStack.back() - 1;
        } else {
          loopStack.pop_back();
        }
        break;
      default:
        break;
      }
      instructionPointer++;
    }
  }

private:
  int _id;

  // TODO: delete me!
  //std::string debug_db_path = "todo_delete_this.db";

  sqlite3 *db;
  char *_sqlite3ErrMsg = 0;
  const std::string sql_query;

  bool doBackup;
  const char *db_file = db_path;

  std::vector<unsigned char> tape;
  std::list<size_t> loopStack;

  size_t instructionPointer;
  int dataPointer;

  /* ============== backup to sqlite3 ============== */

  static int _backup_callback(void *data, int argc, char **argv,
                              char **azColName) {
    for (int i = 0; i < argc; i++) {
      std::cout << azColName[i] << " = " << (argv[i] ? argv[i] : "NULL")
                << "\n";
    }
    std::cout << std::endl;
    return 0;
  }

  void performBackup(void) {
    sqlite3_stmt *stmt;
    std::string tape_str;

    std::cout << "Performing backup for task " << _id << std::endl;

    time_t tm = time(NULL);
    struct tm *current_time = localtime(&tm);
    char *timestamp = asctime(current_time);

    // create the table if it doesn't exist
    if (sqlite3_open(db_file, &db))
      throw std::runtime_error(std::string("sqlite3_open: ") +
                               sqlite3_errmsg(db));

    std::string prepare_table_stmt = "CREATE TABLE IF NOT EXISTS brainflop("
                                     "ID INT PRIMARY          KEY,"
                                     "TASKID		              INT,"
                                     "TIMESTAMP               TEXT,"
                                     "TAPESTATE               TEXT"
                                     " );";

    if (sqlite3_exec(db, prepare_table_stmt.c_str(), NULL, 0,
                     &_sqlite3ErrMsg) != SQLITE_OK)
      throw std::runtime_error(std::string("sqlite3_exec: ") + _sqlite3ErrMsg);

    // insert into database
    if (sqlite3_prepare_v2(db, sql_insert, -1, &stmt, NULL) != SQLITE_OK)
      throw std::runtime_error(std::string("sqlite3_prepare_v2: ") +
                               sqlite3_errmsg(db));

    tape_str.push_back('|');
    for (auto i : tape) {
      tape_str += std::to_string(int(i));
      tape_str.push_back('|');
    }

    sqlite3_bind_int(stmt, 1, _id);
    sqlite3_bind_text(stmt, 2, timestamp, -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 3, tape_str.c_str(), -1, SQLITE_STATIC);

    if (sqlite3_step(stmt) != SQLITE_DONE)
      throw std::runtime_error(std::string("sqlite3_step: ") +
                               sqlite3_errmsg(db));

    sqlite3_finalize(stmt);

    // display contents
    if (sqlite3_exec(db, sql_query.c_str(), _backup_callback, 0,
                     &_sqlite3ErrMsg) != SQLITE_OK)
      throw std::runtime_error(std::string("sqlite3_exec: ") + _sqlite3ErrMsg);
  }

  /* ============== brainflop operations ============== */

  void incrementDataPointer() { dataPointer++; }

  void decrementDataPointer() { dataPointer--; }

  void incrementCellValue() { tape[dataPointer]++; }

  void decrementCellValue() { tape[dataPointer]--; }

  void outputCellValue() { std::cout.put(tape[dataPointer]); }

  void inputCellValue() {
    char inputChar;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    std::cin.get(inputChar);
    tape[dataPointer] = inputChar;
  }

  unsigned char getCellValue() const { return tape[dataPointer]; }
};

void runNewTrial(int id, std::map<int, BFTask *> &task_map) {
  unsigned short tapeSize;
  bool doBackup;
  std::string program;

  tapeSize = 20;
  doBackup =
      parseYesOrNo("[>] Should BRAINFLOP SQL backup mode be enabled (y/n) ? ");

  std::cout
      << "[>] Enter BRAINFLOP program (Enter to finish input and start run): ";
  std::cin >> program;

  BFTask *task = new BFTask(id, tapeSize, doBackup);
  task->run(program, false);
  task_map.insert(std::pair<int, BFTask *>(id, task));
}

void runOnPreviousTrial(int id, std::map<int, BFTask *> &task_map) {
  bool deletePreviousState;
  std::string program;

  BFTask *task = task_map.at(id);
  if (!task) {
    throw std::runtime_error("cannot match ID in task mapping");
  }

  deletePreviousState = parseYesOrNo(
      "[*] Should the previous BRAINFLOP tape state be deleted (y/n) ? ");

  std::cout
      << "[>] Enter BRAINFLOP program (Enter to finish input and start run): ";
  std::cin >> program;

  task->run(program, deletePreviousState);
}

bool parseYesOrNo(const std::string &message) {
  char userAnswer;
  do {
    std::cout << message;
    std::cin >> userAnswer;
  } while (!std::cin.fail() && userAnswer != 'y' && userAnswer != 'n');

  if (userAnswer == 'y')
    return true;

  return false;
}

std::optional<int> parseNumericInput(void) {
  int number;
  try {
    if (!(std::cin >> number)) {
      // Input error or EOF (Ctrl+D)
      if (std::cin.eof()) {
        std::cout << "EOF detected. Exiting." << std::endl;
        exit(-1);
      } else {
        // Clear the error state and ignore the rest of the line
        std::cin.clear();
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cerr << "Invalid input. Please enter an integer." << std::endl;
        return {};
      }
    }
  } catch (const std::exception &e) {
    std::cerr << "An error occurred: " << e.what() << std::endl;
    return {};
  }
  return number;
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin, NULL, _IONBF, 0);

  int id_counter = 1;
  int free_trial_left = 3;
  std::map<int, BFTask *> task_mapping;

  while (true) {
    std::cout << "\n\n[*] WHAT WOULD YOU LIKE TO DO?\n"
              << "    (1) Execute a BRAINFLOP VM (" << free_trial_left
              << " free trials left).\n"
              << "    (2) Open an existing BRAINFLOP VM.\n"
              << "    (3) Goodbye.\n"
              << ">> ";

    if (auto in = parseNumericInput()) {
      switch (*in) {
      case 1:
        if (free_trial_left == 0) {
          std::cerr << "[!] NO MORE VMS FOR YOU!!\n";
          break;
        }
        runNewTrial(id_counter, task_mapping);

        id_counter++;
        free_trial_left--;
        break;

      case 2:
        std::cout << "[*] Enter node ID number >> ";
        if (auto id = parseNumericInput()) {
          if (*id > free_trial_left || *id <= 0) {
            std::cerr << "[!] INVALID NODE ID!!\n";
            break;
          }
          runOnPreviousTrial(*id, task_mapping);
        }
        break;

      case 3:
        std::cout << "Goodbye!\n";
        goto finalize;

      default:
        break;
      }
    }
  }

finalize:

  // free task map items
  for (auto const &[id, task] : task_mapping) {
    task->~BFTask();
  }
  return 0;
}
