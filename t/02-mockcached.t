use strict;
use warnings;
use Test::MockObject;
use Test::More tests => 2;
use Memoize::Cached 'memoize';

our %cache;

BEGIN {  do "t/mock_cached.pl" }

sub foo { $_[0] * 100 }

memoize('foo');

foo(100);

is($cache{'main:foo:100'}, 10000, "foo(100) is cached");
is($cache{'main:foo:200'}, undef, "foo(200) is not cached");
