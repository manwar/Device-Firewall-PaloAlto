# NAME

Device::Firewall::PaloAlto - new module

# VERSION

version 0.01

# SYNOPSIS

# DESCRIPTION

# ERRORS 

# METHODS

## new

## authenticate

## op

Returns a Palo Alto operational object. This object has methods to perform operational tasks on the firewall.

    my $fw_op = Device::Firewall::PaloAlto->new(
                    uri => 'https://firewall.example', 
                    username => 'admin'
                )->auth->op;

# AUTHOR

Greg Foletta <greg@foletta.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Greg Foletta.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
