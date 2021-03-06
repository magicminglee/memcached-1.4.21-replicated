#!/usr/bin/perl

use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib ("$Bin/lib", "$Bin/../t/lib");
use RepcachedTest;

my($m1,$m2) = new_repcached();
my($sock_m1, $sock_m2) = ($m1->sock, $m2->sock);

for my $sock ([$sock_m1, $sock_m2], [$sock_m2, $sock_m1]) {
    my($sock_m, $sock_b) = ($sock->[0], $sock->[1]);

    my $uniq = int(rand()*100000);
    my($key, $val) = ('addtest'.$uniq, 'addval'.$uniq);
    my $vallen = length $val;

    print $sock_m "add $key 0 0 $vallen\r\n$val\r\n";
    is(scalar <$sock_m>, "STORED\r\n", "stored");
    sync_get_is($sock_m, $sock_b, $key, $val);

    my $val2    = 'addval2'.$uniq;
    my $vallen2 = length $val2;

    print $sock_m "add $key 0 0 $vallen2\r\n$val2\r\n";
    is(scalar <$sock_m>, "NOT_STORED\r\n", "not stored");
    sync_get_is($sock_m, $sock_b, $key, $val); # not $val2
}
