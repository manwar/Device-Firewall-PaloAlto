package Device::Firewall::PaloAlto::Op;


use strict;
use warnings;
use 5.010;

use Device::Firewall::PaloAlto::Op::SysInfo;
use Device::Firewall::PaloAlto::Op::Interfaces;
use Device::Firewall::PaloAlto::Op::ARPTable;
use Device::Firewall::PaloAlto::Op::VirtualRouter;

use XML::LibXML;


# VERSION
# PODNAME
# ABSTRACT: Operations module for Palo Alto firewalls

=encoding utf8

=head1 SYNOPSIS

    my $op = Device::Firewall::PaloAlto->new(username => 'admin', password => 'admin')->auth->op;
    my @interfaces = $op->interface->to_array;

=head1 DESCRIPTION

This module holds methods that perform operation commands on the firewall.

=head1 METHODS

=head2 new

The C<new()> method can be used, but in general it's easier to call the C<op()> method from the L<Device::Firewall::PaloAlto> module.

=cut

sub new {
    my $class = shift;
    my ($fw) = @_;

    return bless { fw => $fw }, $class;
}

=head2 system_info

    my $info = $fw->op->system_info;

Returns a L<Device::Firewall::PaloAlto::Op::SysInfo> object containing system information about the firewall.

=cut

sub system_info {
    my $self = shift;

    return Device::Firewall::PaloAlto::Op::SysInfo->_new( $self->_send_op_cmd('show system info') );
}


=head2 interfaces

    my $interfaces = $fw->op->interfaces();

Returns a L<Device::Firewall::PaloAlto::Op::Interfaces> object containing all of the interfaces, both physical and logical, on the device.

=cut

sub interfaces {
    my $self = shift;

    return Device::Firewall::PaloAlto::Op::Interfaces->_new( $self->_send_op_cmd('show interface', 'all') );
}

=head2 arp_table

    my $arp = $fw->op->arp_table();

Returns a L<Device::Firewall::PaloAlto::Op::ARPTable> object representing all of the ARP entries on the device.

=cut


sub arp_table {
    my $self = shift;

    return Device::Firewall::PaloAlto::Op::ARPTable->_new( $self->_send_op_cmd('show arp', { name => 'all' }) );
}

=head2 virtual_router

    # If no virtual router specified, returns the one named 'default'
    my $routing_tables = $fw->op_routing_tables();

    # Retrieve thee 'guest_vr' virtual router
    my $vr = $fw->op->virtual_router('guest_vr');

Returns a L<Device::Firewall::PaloAlto::Op::VirtualRouter> object representing all of the routing tables on the firewall.

=cut


sub virtual_router {
    my $self = shift;
    my ($table_name) = @_;
    $table_name //= 'default';

    return Device::Firewall::PaloAlto::Op::VirtualRouter->_new( $self->_send_op_cmd('show routing route virtual-router', $table_name) );
}

sub _send_op_cmd {
    my $self = shift;
    my ($cmd, $var) = @_;


    return $self->{fw}->_send_request(type => 'op', cmd => _gen_op_xml($cmd, $var));
}


# Generates the proper XML RPC call to go in the operational 'cmd' field.
# The first value is the command, which is split on space and turned into XML, e.g.
# _gen_op_xml('show routing route') => <show><routing><route></route></routing></show>
#
# You can add a variable which becomes text in the last tag, e.g:
# _gen_op_xml('show interface', 'all') => <show><interface>all</interface></show>
# 
# You can add a lead node with an attribute using a hashref as the variable
# _gen_op_xml('show arp', { name => 'all' }) => <show><arp><entry name = 'all'/></arp></show>
#

sub _gen_op_xml {
    my ($command, $variable) = @_;
    my $xml_doc = XML::LibXML::Document->new(); 

    my @command_words = split / /, $command;
    $variable //= '';


    my $leaf;
    if (!ref $variable) {
        $leaf = $xml_doc->createTextNode($variable);
    } elsif (ref $variable eq 'HASH') {
        $leaf = $xml_doc->createElement('entry');
        $leaf->setAttribute(%{ $variable });
    }


    my $parent;
    for my $word (reverse @command_words) {
        # If the child is either the previous parent or the base text node (which could be an empty string)
        my $child = $parent // $leaf;
        $parent = $xml_doc->createElement($word);
        $parent->appendChild($child);
    }

    return $parent->toString;
}


1;

