use 5.010;
use strict;
use warnings;
use Test::More tests => 3;
use Cache::Memcached;
use Memoize::Cached 'memoize';

sub foo { $_[0] * 100 }
sub bar { $_[0] * 200 }
sub baz { $_[0] * 300 }

memoize(qw/foo bar/);

foo(100);
bar(100);
baz(100);

my $cached = Memoize::Cached->default_cached;
my $key_generator = Memoize::Cached->default_key_generator;

is($cached->get($key_generator->('main', 'foo', 100)),
   10000, 'result of foo is cached');
is($cached->get($key_generator->('main', 'bar', 100)),
   20000, 'result of bar is cached');
is($cached->get($key_generator->('main', 'baz', 100)),
   undef, 'result of baz is not cached');
