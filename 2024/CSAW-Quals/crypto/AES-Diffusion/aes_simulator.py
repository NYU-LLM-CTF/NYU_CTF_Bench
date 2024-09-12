N_ROWS = 4
N_COLS = 4

def CyclicShift(row, shift):
    return row[shift:] + row[:shift]

def ShiftRows(state):
    for row_index in range(N_ROWS):
        state[row_index] = CyclicShift(state[row_index], row_index)
    return state

def BuildExpressionString(column, matrix_row):
    expression = "("
    for (i,coefficient) in enumerate(matrix_row):
        term = str(coefficient) + "*" + column[i]
        should_insert_plus = i < len(matrix_row) - 1
        expression += term
        
        if should_insert_plus:
            expression += " + "
    return expression + ")"

def GetStateColumn(state, column_index):
    column = []
    for row in state:
        column.append(row[column_index])
    return column

def MultiplyColumn(column):
    matrix = [
                [2, 3, 1, 1],
                [1, 2, 3, 1],
                [1, 1, 2, 3],
                [3, 1, 1, 2]
            ]
    
    new_column = []
    for row in matrix:
        new_element = BuildExpressionString(column, row)
        new_column.append(new_element)
    return new_column

def MixColumns(state):
    new_columns = []
    for column_index in range(N_COLS):
        column = GetStateColumn(state, column_index)
        new_column = MultiplyColumn(column)
        new_columns.append(new_column)
    
    return Transpose(new_columns)

def Transpose(matrix):
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]

def PrettyPrint(matrix):
    for row in matrix:
        print(row)

def PrettyPrint2(matrix):
    for row in matrix:
        for element in row:
            print(element)

state = [["x0", "x4", "x8", "x12"], 
         ["x1", "x5", "x9", "x13"], 
         ["x2", "x6", "x10", "x14"],
         ["x3", "x7", "x11", "x15"]]

def AESRound(state):
    return MixColumns(ShiftRows(state))

def AES(state, rounds):
    for r in range(rounds):
        state = AESRound(state)
    return state

PrettyPrint(AES(state,2))
