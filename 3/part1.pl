#!/usr/bin/perl

use strict;
use warnings;

require "./advent3.pl";

if (!defined $ARGV[0]) {
    print "First argument needs to be input filename. Leaving.\n";
    exit;
}

my $filename = $ARGV[0];
my $result = do_things($filename);
print($result);
