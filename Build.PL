use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Memoize::Cached',
    license             => 'perl',
    dist_author         => 'Tom Tsuruhara <tom.lpsd@gmail.com>',
    dist_version_from   => 'lib/Memoize/Cached.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Memoize-Cached-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
