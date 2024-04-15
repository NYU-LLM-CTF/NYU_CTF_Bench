cd ~/procrastination-simulator/challenge
# Clean up any existing deployment of the challenge docker containers
rm first_password.txt
rm -rf binaries
docker stop $(docker container ls -q)
docker system prune -af
# Create new docker containers
python3 generate_challenge.py
# And that's it! Now people can nc to `auto-pwn.chal.csaw.io:11001` using the password
# stored in ~/procrastination-simulator/challenge/first_password.txt.
# Since I use the same random seed to produce the challenge every time,
# that first password won't change and therefore there's no need to 
# update the `challenge.json` file after redeploying the challenges.
# If you're feeling cautious, though, after running this script check 
# the value in ~/procrastination-simulator/challenge/first_password.txt 
# against what is in the CTFd challenge descrption.
#
# To the player, for running this locally:
# In the `challenge` folder run run generate_challenge.py, this will produce first_password.txt.
# Now you can solve the challenges.
# If you get stuck and want to run the solver script, copy that first_password.txt file into the `challenge/solver` folder.
# Then cd into that folder and you can run solver.py.
# Note that the solver script will not work every time.
# We never bothered to write an optimized solver script for this challenge.
# Lots of the code could have been optimized or cleaned up as well.
# But it works so we shipped it!
# We encourage you to write your own auto-pwning challenges with this framework.
