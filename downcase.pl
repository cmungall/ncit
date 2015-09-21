#!/usr/bin/perl
while(<>) {
    if (/^name:/) {
        tr/A-Z/a-z/;
    }
    elsif (/^synonym: \"(.*)\" (.*)/) {
        $_ = 'synonym: "'.lc($1)." $2";
    }
    print $_;
}
