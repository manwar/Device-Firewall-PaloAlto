package Device::Firewall::PaloAlto::Op::VirtualRouter;

use strict;
use warnings;
use 5.010;

# VERSION
# PODNAME
# ABSTRACT: new module

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
    my %tables = %{$api_return};

    return bless \%tables, $class;
}


1;
