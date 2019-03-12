package Device::Firewall::PaloAlto;

use strict;
use warnings;
use 5.010;

use parent 'Device::Firewall::PaloAlto::API';

use Device::Firewall::PaloAlto::Op;

# VERSION
# PODNAME
# ABSTRACT: new module

=encoding utf8

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ERRORS 

=head1 METHODS

=head2 new

=cut

=head2 authenticate

=cut

=head2 op

Returns a Palo Alto operational object. This object has methods to perform operational tasks on the firewall.

    my $fw_op = Device::Firewall::PaloAlto->new(
                    uri => 'https://firewall.example', 
                    username => 'admin'
                )->auth->op;

=cut

sub op {
    my $self = shift;

    return Device::Firewall::PaloAlto::Op->new($self);
}


1;
