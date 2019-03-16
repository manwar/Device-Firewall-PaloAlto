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

    use Device::Firewall::PaloAlto;
    
    my $fw = Device::Firewall::PaloAlto->new(
        uri => 'https://pa.localdomain',
        username => 'user11',
        password => 'a_password'
    );

    fw->auth or die "Could not authenticate";

    for my $interface ($fw->op->interfaces) {
        say "Name: ". $interface->name;
    }

=head1 DESCRIPTION

This module provides an interface to the Palo Alto firewall API.

=head1 ERRORS 

=head1 METHODS

=head2 new

    my $fw = Device::Firewall::PaloAlto(
        uri => 'https://pa.localdomain',
        username => 'user',
        password => 'pass',
        ssl_opts => { verify_hostname => 1 }
    );

The C<new()> method creates a new Device::Firewall::PaloAlto object. The uri, username and password can be
passed in using the environment variables 'PA_FW_URI', PA_FW_USERNAME and PA_FW_PASSWORD. If no environment
variables are set, the username and password both default to 'admin'.

The SSL options 

=cut

=head2 auth

This function authenticates the credentials passed to new against the firewall.

In either a successful or unsuccessful authentication, the object itself is still returned. This allows method calls to be chained together:

    my $fw_op = $fw->auth->op();

Authentication errors will surface in the form of errors returned from specific firewall calls.

=cut

=head2 op

Returns a L<Device::Firewall::PaloAlto::Op> object. This object has methods to perform operational tasks on the firewall.

    my $fw_op = $fw->auth->op();
    my $interfaces = $fw_op->interfaces();

=cut

sub op {
    my $self = shift;

    return Device::Firewall::PaloAlto::Op->new($self);
}


1;
