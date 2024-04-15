cd ~/auto-pwn
# Clean up any existing deployment of the challenge docker containers
rm first_password.txt
rm -rf binaries
docker stop $(docker container ls -q) 
docker system prune -af
# Create new docker containers
python3 generate_challenge.py
# And that's it! Now people can nc to `auto-pwn.chal.csaw.io:11001` using the password
# stored in ~/auto-pwn/first_password.txt.
# Since I use the same random seed to produce the challenge every time,
# that first password won't change and therefore there's no need to 
# update the `challenge.json` file after redeploying the challenges.
# If you're feeling cautious, though, after running this script check 
# the value in ~/auto-pwn/first_password.txt 
# against what is in the CTFd challenge descrption.
#
# To the player, for running this locally:
# In the `challenge` folder run run generate_challenge.py, this will produce first_password.txt.
# If you get stuck and want to run the solver script, copy that first_password.txt file into the `challenge/solver` folder.
# Then, in /etc/hosts, set auto-pwn.chal.csaw.io to resolve to localhost (instructions are in solver/solver.py).
# Now you can solve the challenges. When you're done, consider commenting out your addition to /etc/hosts.
# Then cd into that folder and you can run solver.py.
# Note that the solver script may get stuck, time out and 
# re-attempt solving a level. So give it a few seconds to 
# right itself as it runs.
# 
# We encourage you to write your own auto-pwning challenges with this framework.
# Happy hacking!
