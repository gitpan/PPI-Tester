#!/usr/bin/perl -w

# Just load test the PPI::Tester application

use strict;
use Test::More 'tests' => 2;

BEGIN {
	$|++;
	ok( $] >= 5.005, 'Your perl is new enough' );
}

use_ok( 'PPI::Tester' );

1;
