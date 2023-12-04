#!/usr/bin/perl

use strict;
use warnings;
use Test::Simple tests => 3;

require "./advent3.pl";

my @test_data = split "\n", 
ok(do_things('testdata.txt', 'p1', 1) == 4361, 'parts sum is calculated properly with testdata');
ok(do_things('testdata.txt', 'p2', 1) == 467835, 'gears sum is calculated properly with testdata');

ok(process_line_p2(undef, '...100*010--', undef, 1) == 1000, 'specific case of single line gear');