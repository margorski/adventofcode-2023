#!/usr/bin/perl

use strict;
use warnings;
use Test::Simple tests => 1;

require "./advent3.pl";

my @test_data = split "\n", 
ok(do_things('testdata.txt') == 4361, 'parts sum is calculated properly with testdata');