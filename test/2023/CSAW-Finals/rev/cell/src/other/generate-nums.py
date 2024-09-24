import random

# List of available numbers
number_list = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768]

# Initialize the result list with 0s
result_list = [0] * 1008

# Generate 5004 bytes in groups of 16
for i in range(0, len(result_list), 16):
    random_indices = random.sample(range(16), 2)  # Choose two random indices within the group
    print(random_indices)
    for j in range(2):
        result_list[i + random_indices[j]] = number_list[random_indices[j]]
        print(result_list[i + random_indices[j]])

# Print the result list (first 60 bytes as an example)
# print(result_list[:60])

# write this to a file
with open("numbers.txt", "w") as f:
    f.write(str(result_list))