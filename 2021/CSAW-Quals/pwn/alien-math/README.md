#Alien Math

This challenge requires the player to determine the correct input for the first two questions, then perform a simple buffer overflow on the third question.
- Question 1 - Requires the player to recognize that rand() will produce the same number for every run of the program
- Question 2 - Player should use Angr to determine the correct input and reach the third question
- Question 3 - Abuse use of gets() to overflow to print_flag function
