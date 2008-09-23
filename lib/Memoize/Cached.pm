package Memoize::Cached;
use 5.010;
use warnings;
use strict;
use Carp qw(croak);
use base 'Exporter';

our @EXPORT_OK = qw(memoize);

=head1 NAME

Memoize::Cached - memoize function with memcached

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use Memoize::Cached qw(memoize);

    sub foo { ...heavy process... }

    memoize('foo');

=head1 EXPORT

meoize

=cut
use Cache::Memcached;

my %config;

sub import {
    my ($class, @args) = @_;
    my $pkg = caller;
    @_ = ($class);
    $config{$pkg} = {};
    while (my $arg = shift @args) {
        if ($arg =~ /^-(\w+)/) {
            $config{$pkg}{lc $1} = shift @args;
            next;
        }
        push @_, $arg;
    }
    goto \&Exporter::import;
}

my %defaults = (
    cached => Cache::Memcached->new({
        servers => ['127.0.0.1:11211']
    }),
    key => sub {
        return join ':', @_;
    },
    expire => 0,
);

sub default_cached {
    return $defaults{cached};
}

sub default_key_generator {
    return $defaults{key};
}

sub default_expire_time {
    return $defaults{expire};
}

sub memoize {
    my $pkg = caller;
    my %config = (%defaults, %{$config{$pkg}});
    my @subnames = @_;
    if (ref $_[0] eq 'HASH') {
        my %args = %{$_[0]};
        @subnames = @{delete $args{subnames}};
        %config = (%config, %args);
    }
    my $cached = $config{cached};
    $cached = $cached->() if ref $cached eq 'CODE';

    croak "cached object does not implement get method"
        unless $cached->can('get');
    croak "cached object does not implement set method"
        unless $cached->can('set');

    no strict;
    no warnings 'redefine';
    for my $subname (@subnames) {
        my $code = $pkg->can($subname);
        *{"$pkg\::$subname"} = sub {
            my $key = $config{key}->($pkg, $subname, @_);
            my $val = $cached->get($key);
            return $val if defined($val);
            $val = $code->(@_);
            $cached->set($key, $val, $config{expire});
            return $val;
        };
    }
}


=head1 AUTHOR

Tom Tsuruhara, C<< <tom.lpsd at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-memoize-cached at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Memoize-Cached>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Memoize::Cached


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Memoize-Cached>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Memoize-Cached>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Memoize-Cached>

=item * Search CPAN

L<http://search.cpan.org/dist/Memoize-Cached>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Tom Tsuruhara, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Memoize::Cached
