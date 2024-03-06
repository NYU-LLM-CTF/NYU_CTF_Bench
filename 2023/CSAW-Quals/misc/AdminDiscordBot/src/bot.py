#############################################
# Author: Krishnan Navadia
# This is main working file for this chal
#############################################

import discord
from discord.ext import commands, tasks
import subprocess

from settings import ADMIN_ROLE
import os
from dotenv import load_dotenv
from time import time

load_dotenv()

TOKEN = os.getenv("TOKEN")

intents = discord.Intents.default()
intents.messages = True
bot = commands.Bot(command_prefix="!", intents=intents)

bot.remove_command('help')

SHELL_ESCAPE_CHARS = [":", "curl", "bash", "bin", "sh", "exec", "eval,", "|", "import", "chr", "subprocess", "pty", "popen", "read", "get_data", "echo", "builtins", "getattr"]


@tasks.loop(seconds=10)
async def my_background_task():
    print('checking processed')
    WORD = "python"
    output = subprocess.check_output("ps -ef", shell=True).decode()
    for line in output.split("\n"):
        things = line.split()
        if len(things) == 0:
            continue

        if WORD in line:
            pid = things[1]
            if pid.strip() == "1":
                continue
            print(f"killing this process", pid)
            try:
                os.system(f"kill -9 {str(pid)}")
            except Exception as e:
                print('error', e)


def excape_chars(strings_array, text):
    return any(string in text for string in strings_array)

def pyjail(text):
    if excape_chars(SHELL_ESCAPE_CHARS, text):
        return "No shells are allowed"

    text = f"print(eval(\"{text}\"))"
    proc = subprocess.Popen(['/usr/sbin/chroot', '--userspec=999:1000', '/app', './interpret/bin/python3', '-c', text], stdout=subprocess.PIPE, preexec_fn=os.setsid)
    output = ""
    try:
        out, err = proc.communicate(timeout=1)
        output = out.decode().replace("\r", "")
        print(output)
        print('terminating process now')
        proc.terminate()
    except Exception as e:
        proc.kill()
        print(e)

    if output:
        return f"```{output}```"


@bot.event
async def on_ready():
    print(f'{bot.user} successfully logged in!')

@bot.command(name="flag", pass_context=True)
async def flag(ctx):
    admin_flag = any(role.name == ADMIN_ROLE for role in ctx.message.author.roles)

    if admin_flag:
        cmds = "Here are some functionalities of the bot\n\n`!add <number1> + <number2>`\n`!sub <number1> - <number2>`"
        await ctx.send(cmds)
    else:
        message = "Only 'admin' can see the flag.😇"
        await ctx.send(message)

@bot.command(name="add", pass_context=True)
async def add(ctx, *args):
    admin_flag = any(role.name == ADMIN_ROLE for role in ctx.message.author.roles)
    if admin_flag:
        arg = " ".join(list(args))
        user_id = ctx.message.author.id
        ans = pyjail(arg)
        if ans: await ctx.send(ans)
    else:
        await ctx.send("no flag for you, you are cheating.😔")

@bot.command(name="sub", pass_context=True)
async def sub(ctx, *args):
    admin_flag = any(role.name == ADMIN_ROLE for role in ctx.message.author.roles)
    if admin_flag:
        arg = " ".join(list(args))
        ans = pyjail(arg)
        if ans: await ctx.send(ans)
    else:
        await ctx.send("no flag for you, you are cheating.😔")


@bot.command(name="help", pass_context=True)
async def help(ctx, *args):
    await ctx.send("Try getting `!flag` buddy... Try getting flag.😉")


@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.CommandNotFound):
        await ctx.send("Try getting `!flag` buddy... Try getting flag.😉")
    else:
        print(f'Error: {error}')



@my_background_task.before_loop
async def my_background_task_before_loop():
    await bot.wait_until_ready()


my_background_task.start()
bot.run(TOKEN)
