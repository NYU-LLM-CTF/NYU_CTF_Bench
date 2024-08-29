# Smuggling Mail
Challenge description: `Join our waitlist and we'll let you know about apartment vacancies!`
<details>
    <summary>Contains vulnerability/exploit spoilers</summary>
    As heavily hinted to by the name, this challenge combines HTTP request smuggling with command injection functionality in the popular `mail` program.
    The request smuggling is made possible because of how certain versions of Varnish mishandle HTTP/2 connections that are proxied to the backend.
    The command injection is then triggered by using the `mail` utility's built-in tilde escape functionality to run a shell command included in the email's body content.
</details>

## Development notes
The `smuggling-mail.tar.gz` file contains everything needed to run the challenge and test it locally.
The Docker container can be built and deployed using the provided `run.sh` script.

