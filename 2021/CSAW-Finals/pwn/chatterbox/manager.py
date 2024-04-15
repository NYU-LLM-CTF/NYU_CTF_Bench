CREDS = {
'ctf0': 'lom5rItDLjdaA0',
'ctf1': 'k8mXQIjY5cJaA0',
'ctf2': '6GX01ZAPRXuaA0',
'ctf3': 'rGxsTAVrjQwaA0',
'ctf4': 'VqofGwmqfJxaA0',
'ctf5': 'umB87xavZPSaA0',
'ctf6': 'hSk7xs7iTRCaA0',
'ctf7': 'SwQR09ykR4YaA0',
'ctf8': 'RBtMrf6vl9BaA0',
'ctf9': 'WxzLId7OC6EaA0',
'ctf10': 'uj21b8zDLzraA0',
'ctf11': 'THQXKBXbSb5aA0',
'ctf12': '8m7ncdufqjFaA0',
'ctf13': 'OL4GY0j3BinaA0',
'ctf14': 'IQ1xHE9GSjXaA0',
'ctf15': 'sdcK5dumSbtaA0',
'ctf16': 'qCZcUOW5BOzaA0',
'ctf17': 'gXVxXFbG3H9aA0',
'ctf18': 'qwf3I0Kw0FjaA0',
'ctf19': 'oDfn5htx0RjaA0',
'ctf20': 'RD8NaZvWroNaA0',
'ctf21': '10PPyF8M0lTaA0',
'ctf22': 'LJMxtWYktChaA0',
'ctf23': 'ABJ3kQN8mQlaA0',
'ctf24': 'MK9F8veNlbAaA0',
'ctf25': 'hBi6g99TI6oaA0',
'ctf26': 'nbqm8fYB9Z0aA0',
'ctf27': 'oAoX9euL5aaaA0',
'ctf28': 'XrS4y6TkoFAaA0',
'ctf29': 'Vk2azPTSm29aA0',
'ctf30': 'hcGK8KaVWM6aA0',
'ctf31': 'hxjnSlGJ76kaA0',
'ctf32': 'Q2xjSRROrWZaA0',
'ctf33': 'mJ8zbaSS24WaA0',
'ctf34': 'XXo1EqEONJCaA0',
'ctf35': 'jDq4jk6rRELaA0',
'ctf36': 'rhp192uL7tkaA0',
'ctf37': '6Yx6wm35WSgaA0',
'ctf38': 'w7sCvmtH40RaA0',
'ctf39': 'DV4nZxaWlryaA0',
'ctf40': 'HMyfF12sdSJaA0',
'ctf41': 'tz2We9LZb88aA0',
'ctf42': 'X5gcZbaHLWMaA0',
'ctf43': '8h0AUcUMUfcaA0',
'ctf44': '697QxESDTaCaA0',
'ctf45': '9LXeIyyHvbbaA0',
'ctf46': '7JMZOSjT3RoaA0',
'ctf47': '4qmP0DVtlKxaA0',
'ctf48': 'uXZf89q6Qn7aA0',
'ctf49': '06Gr9Ns3MUqaA0',
'ctf50': 'Y7u5Jpsd9RVaA0',
'ctf51': 'f9iP7riHmoZaA0',
'ctf52': 'dsTgDZqBeQ9aA0',
'ctf53': '0FX2ppx5WsoaA0',
'ctf54': 'zIY1SNZYyO5aA0',
'ctf55': 'ahQLf6c4zBsaA0',
'ctf56': 'sE4IYfIv0JXaA0',
'ctf57': 'ZLFg2oAfmWjaA0',
'ctf58': 'nqHCdLXGxJZaA0',
'ctf59': 'VidmZpaoQ1MaA0',
}
NUM_TEAMS = len(CREDS)


import os, sys, time, threading, re, subprocess, time, socket, atexit
import wmi

BASE_PORT = 1300

SERVER_RUNNING = True

def kill_all_servers():
    os.system('taskkill /f /im server.exe >nul')

def atexit_hook():
    global SERVER_RUNNING
    SERVER_RUNNING = False
    kill_all_servers()

atexit.register(atexit_hook)

# this is really stupid but it will suffice
def do_team_thread(user, port):
    password = CREDS[user]
    cmd = 'c:\\SysinternalsSuite\\PsExec.exe -l -nobanner -user %s -p %s "c:\\server.exe" 0.0.0.0 %d' % (user, password, port)
    while SERVER_RUNNING:
        try:
            subprocess.call(cmd)
            time.sleep(0.1)
        except Exception as e:
            print('server ' + user + ' ' + str(port) + ' error:')
            print(e)

def poll_processes():
    ports_to_processes = {}
    wmic = wmi.WMI()
    for p in wmic.Win32_Process():
        try:
            pid = p.ProcessId
            path = p.ExecutablePath
            cmdline = p.CommandLine
        except:
            print('Weird process', pid)
            continue
        if not path:
            continue
        if path.lower() == 'c:\\server.exe':
            args = cmdline.split(' ')
            port = int(args[2])
            ports_to_processes[port] = int(pid)
    return ports_to_processes

def health_check(port):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)
        s.connect(('127.0.0.1', port))
        s.send(b'\x02\x00\x00\x00\x04\x00\x00\x00ABCD')
        time.sleep(0.5) # this is dumb.
        response = s.recv(2048)
        assert response.endswith(b'\x02\x00\x00\x00\x04\x00\x00\x00ABCD')
        s.close()
        return True
    except Exception as e:
        print('Health check to port %d failed:' % port)
        print(repr(e))
        return False

def kill_process(pid):
    print('Killing process pid %d' % pid)
    try:
        os.system('taskkill /f /pid %d' % pid)
        return True
    except Exception as e:
        print('Failed to kill pid %d:' % pid)
        print(e)
        return False

def do_health_check(port, results):
    ok = health_check(port)
    if not ok:
        print('Server for port %d is hung' % port)
        results.append(port)
    else:
        print('Server for port %d is OK' % port)

def check_and_restart_servers():
    print('Checking all servers.')
    threads = []
    dead_ports = []
    for i in range(NUM_TEAMS):
        port = BASE_PORT + i
        t = threading.Thread(target=do_health_check, args=(port, dead_ports)) # this is dumb.
        t.daemon = True
        t.start()
        threads.append(t)
    for t in threads:
        t.join()

    if dead_ports:
        ports_to_processes = poll_processes()
        for port in dead_ports:
            server_pid = ports_to_processes.get(port)
            if server_pid:
                kill_process(server_pid)
            else:
                print('Server for port %d is not running??? wtf?' % port)

def start_team_threads():
    threads = []
    print('Starting %d servers' % NUM_TEAMS)
    for i in range(NUM_TEAMS):
        port = BASE_PORT + i
        user = 'ctf%d' % i
        t = threading.Thread(target=do_team_thread, args=(user,port))
        t.daemon = True
        t.start()
        threads.append(t)
    return threads

def shutdown(threads):
    global SERVER_RUNNING
    SERVER_RUNNING = False
    kill_all_servers()
    for t in threads:
        t.join()

kill_all_servers()

threads = start_team_threads()

try:
    i = 0
    while True:
        time.sleep(60)
        check_and_restart_servers()
        i += 1
        if i % 60 == 0: # restart servers every 60 mins (deal with any shit like memory leaks)
            kill_all_servers()
except KeyboardInterrupt:
    print('Received ^C, quitting')

shutdown(threads)
