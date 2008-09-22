#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'Memoize::Cached', 'memoize' );
}

diag( "Testing Memoize::Cached $Memoize::Cached::VERSION, Perl $], $^X" );

ok(__PACKAGE__->can('memoize'), 'export memoize');
