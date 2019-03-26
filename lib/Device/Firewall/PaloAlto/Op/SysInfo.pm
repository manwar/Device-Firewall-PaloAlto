package Device::Firewall::PaloAlto::Op::SysInfo;

use strict;
use warnings;
use 5.010;

# VERSION
# PODNAME
# ABSTRACT: Palo Alto firewall system information

use parent qw(Device::Firewall::PaloAlto::JSON);

=encoding utf8

=head1 SYNOPSIS

=head1 DESCRIPTION

This object represents the system information of the Palo Alto firewall.

=cut

sub _new {
    my $class = shift;
    my ($api_return) = @_;
    my %system_info = %{$api_return->{result}{system}};
    

    return bless \%system_info, $class;
}


=head1 METHODS


=head2 hostname

Returns the hostname of the device.

=cut

=head2 mgmt_ip

Returns the IPv4 address of the management interface.

=cut

sub hostname { return $_[0]->{hostname} }
sub mgmt_ip { return $_[0]->{'ip-address'} }

1;

