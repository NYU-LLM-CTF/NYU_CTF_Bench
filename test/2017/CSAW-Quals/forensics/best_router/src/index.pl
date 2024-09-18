#!/usr/bin/perl

print "Content-type:text/html\r\n\r\n";

print "<html>";
print "<head>";
print "<title>[ BEST ROUTER ]</title>";
print "</head>";
print "<body>";
print "<form method='POST' action='login.pl'>";
print "<p>Username:</p>";
print "<input type='text' name='username'>";
print "<p>Password:</p>";
print "<input type='password' name='password'>";
print "<br>";
print "<br>";
print "<input type='submit'>";
print "</form>";
print "</body>";
print "</html>";

1;

