# NAME

Device::Firewall::PaloAlto - new module

# VERSION

version 0.01

# SYNOPSIS

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

# DESCRIPTION

This module provides an interface to the Palo Alto firewall API.

# ERRORS 

# METHODS

## new

    my $fw = Device::Firewall::PaloAlto(
        uri => 'https://pa.localdomain',
        username => 'user',
        password => 'pass',
        ssl_opts => { verify_hostname => 1 }
    );

The `new()` method creates a new Device::Firewall::PaloAlto object. The uri, username and password can be
passed in using the environment variables 'PA\_FW\_URI', PA\_FW\_USERNAME and PA\_FW\_PASSWORD. If no environment
variables are set, the username and password both default to 'admin'.

The SSL options 

## auth

This function authenticates the credentials passed to new against the firewall.

In either a successful or unsuccessful authentication, the object itself is still returned. This allows method calls to be chained together:

    my $fw_op = $fw->auth->op();

Authentication errors will surface in the form of errors returned from specific firewall calls.

## op

Returns a [Device::Firewall::PaloAlto::Op](https://metacpan.org/pod/Device::Firewall::PaloAlto::Op) object. This object has methods to perform operational tasks on the firewall.

    my $fw_op = $fw->auth->op();
    my $interfaces = $fw_op->interfaces();

# AUTHOR

Greg Foletta <greg@foletta.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Greg Foletta.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
