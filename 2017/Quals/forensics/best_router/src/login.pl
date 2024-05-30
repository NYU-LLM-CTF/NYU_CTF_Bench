#!/usr/bin/perl

if ($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    @pairs = split(/&/, $buffer);
    foreach $pair (@pairs) {
        ($name, $value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $FORM{$name} = $value;
    }
}

open(FH,"username.txt") or &dienice("Can't open username.txt: $!");
$username = <FH>;
close(FH);

open(FH,"password.txt") or &dienice("Can't open password.txt: $!");
$password = <FH>;
close(FH);

open(FH,"flag.txt") or &dienice("Can't open flag.txt: $!");
$flag = <FH>;
close(FH);

print "Content-type:text/html\r\n\r\n";

if ($FORM{"username"} eq $username && $FORM{"password"} eq $password){
    print "<html>";
    print "<head>";
    print "<title>[ BEST ROUTER ]</title>";
    print "</head>";
    print "<body>";
    print "<p>Authenticated</p>";
    print "<pre>$flag</pre>";
    print "</body>";
    print "</html>";
    exit 0;
} else {
    print "<html>";
    print "<head>";
    print "<title>[ BEST ROUTER ]</title>";
    print "</head>";
    print "<body>";
    print "<center><p>Sorry, your credentials are wrong</p></center>";
    print "</body>";
    print "</html>";
    exit 0;
}

