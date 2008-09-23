use Test::MockObject;

my $mock = Test::MockObject->new;

our %cache;
$mock->fake_module(
    'Cache::Memcached',
    get => sub {
        my ($self, $key) = @_;
        $cache{$key}
    },
    set => sub {
        my ($self, $key, $val) = @_;
        $cache{$key} = $val;
    }
);

sub cache {
    return \%cache;
}

1;
