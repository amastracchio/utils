#!/usr/bin/perl
use strict;

my $cad;
my $tty = "/root/3p/bin/oysttyer.pl -autosplit=word ";

open(FILE, ">>/tmp/alert_twitter.log");

print FILE "Start $0\n";

foreach (@ARGV){
	print FILE "param: ".$_ . "\n";
}


while (<STDIN>) {
	    # or simply "print;"
	    chop;
	    $cad .= $_;
}
my $com = $tty ." -status=\"$cad\" >>/tmp/oystertty.log 2>\&1";

print FILE $cad;
print FILE "Por ejecutar $com\n";
my $ret = system($com);
print FILE  "Devolvio= $ret\n";
close FILE;

