# Admin Discord Bot

# Solution

1. As we can only get flag if we have `admin` role, so make a new server and give yourself `admin` role.
   https://discord.com/api/oauth2/authorize?client_id=1136271274667167835&permissions=8&scope=bot

2. Then use `!flag` to get further instruction. We can see we have two new commands `!add` and `!sub`

3. Here there is `pyjail` vulnerability. Use the following payload to get the flag.
   `!add __loader__().load_module('os').system('cat flag.txt')`
