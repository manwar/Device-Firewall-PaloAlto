package Device::Firewall::PaloAlto::Op::ARPEntry;

use strict;
use warnings;
use 5.010;

# VERSION
# PODNAME
# ABSTRACT: Palo Alto firewall ARP entry

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

    # Clean up the status field and transform into meaningful strings instead of single characters
    my %status_map = ( s => 'static', c => 'complete', e => 'expiring', i => 'incomplete' );
    my ($cleaned_status) = $api_return->{status} =~ m{\s+(\w)\s+}ms;
    $api_return->{status} = $status_map{$cleaned_status};

    return bless $api_return, $class;
}

=head2 mac

Returns the MAC address of the ARP entriy. Alphabetic hex digits are always in lower case.

=cut

sub mac { return lc $_[0]->{mac} }

=head2 status

Returns the status of the ARP entry. Can either be 'static', 'complete', 'expiring' or 'incomplete'

=cut

sub status { return $_[0]->{status} }


1;

