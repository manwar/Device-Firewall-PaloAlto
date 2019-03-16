package Device::Firewall::PaloAlto::Op::VirtualRouter;

use strict;
use warnings;
use 5.010;

# VERSION
# PODNAME
# ABSTRACT: new module

use Device::Firewall::PaloAlto::Op::Route;

use parent qw(Device::Firewall::PaloAlto::JSON);

=encoding utf8

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ERRORS 

=head1 METHODS

=cut 

sub _new {
    my $class = shift;
    my ($api_return) = @_;
    my %virtual_router;

    my @routes = @{$api_return->{result}{entry}};
    %virtual_router = map { $_->{destination} => Device::Firewall::PaloAlto::Op::Route->_new($_) } @routes;

    return bless \%virtual_router, $class;
}

=head2 route

    my $default_route = $fw->op->virtual_router('default')->route('0.0.0.0/0');

Returns a L<Device::Firewall::PaloAlto::Op::Route> object if the route exists in the routing table.

Returns 'undef' if the route does not exist in the routing table;

=cut

sub route { 
    my $self = shift;
    my ($prefix) = @_;
    return $self->{$prefix};
}


1;

