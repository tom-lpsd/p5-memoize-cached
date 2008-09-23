use strict;
use warnings;
use Test::More 'no_plan';
use Memoize::Cached 'memoize';

BEGIN { do "t/mock_cached.pl" }

our $global = 100;

sub foo {
    $global += 100;
    $_[0] * 100;
}

memoize('foo');

foo(100);
foo(100);

is($global, 200, 'side effect occured only once');
