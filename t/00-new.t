use strict;
use warnings;
use 5.010;

use Device::Firewall::PaloAlto;

use Test::More;

ok( Device::Firewall::PaloAlto->new(uri => 'https://localhost', username => 'admin', password => 'password'), "new() with 3 args" );

ok( !Device::Firewall::PaloAlto->new(uri => 'scheme://localhost', username => 'admin', password => 'password'), "Incorrect Scheme" );

done_testing();
