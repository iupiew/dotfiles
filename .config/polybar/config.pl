#!/usr/bin/env perl
use strict;
use warnings;

sub get_ip {
    my $ip = `curl -s ifconfig.me`;
    chomp $ip;
    return $ip;
}

sub get_country_code {
    my $json = `curl -s https://wtfismyip.com/json`;
    return ($json =~ /"YourFuckingCountryCode":\s*"([^"]+)"/) ? $1 : undef;
}

sub main {
    my $ip = get_ip();
    my $country = get_country_code();
    
    if ($ip && $country) {
        print "$ip ($country)\n";
    } elsif ($ip) {
        print "$ip\n";
    } else {
        print "N/A\n";
    }
}

main();
