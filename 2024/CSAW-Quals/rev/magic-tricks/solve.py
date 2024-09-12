from z3 import *

# Get the output into a list
with open('output.txt', 'r') as file:
    output = [ord(char) for char in file.read().strip()]

solver = Solver()

n = len(output)

# Create variables for each char of input
input_vars = [BitVec(f'input_{i}', 8) for i in range(n)]  # 8-bit values to represent each character

# Apply the mangling to each input
for i in range(n):
    solver.add(((input_vars[i] + 23) ^ (input_vars[i] - 1) << 1) % 4 + input_vars[i] * 2 - 32 == output[i])

# adding in the ASCII printable constrants
for i in range(n):
    solver.add(input_vars[i] >= 32, input_vars[i] <= 126)  # Assuming ASCII printable characters

# Check for solutions
if solver.check() == sat:
    model = solver.model()
    result = ''.join(chr(model[input_vars[i]].as_long()) for i in range(n))
    print("Flag: ", result)
else:
    print("No solution found.")
