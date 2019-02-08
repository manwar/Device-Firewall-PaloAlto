package Device::Firewall::PaloAlto::Op;

use strict;
use warnings;
use 5.010;

use XML::LibXML;

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

sub new {
    my $class = shift;
    my ($fw) = @_;

    return bless { fw => $fw }, $class;
}


=head2 interfaces

=cut

sub interfaces {
    my $self = shift;

    return $self->_send_op_cmd('show interface', 'all');
}

sub routes {
    my $self = shift;

    return $self->_send_op_cmd('show routing route');
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

sub _gen_op_xml {
    my ($command, $variable) = @_;

    my @command_words = split / /, $command;
    $variable //= '';

    my $xml_doc = XML::LibXML::Document->new(); 

    my $parent;
    for my $word (reverse @command_words) {
        # If the child is either the previous parent or the base text node (which could be an empty string)
        my $child = $parent // $xml_doc->createTextNode($variable); 
        $parent = $xml_doc->createElement($word);
        $parent->appendChild($child);
    }

    say STDERR $parent->toString;
    return $parent->toString;
}

1;

