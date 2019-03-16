use Test::More;

use Device::Firewall::PaloAlto;

my $fw = Device::Firewall::PaloAlto->new(uri => 'http://pa.localdomain', username => 'admin', password => 'admin');

isa_ok( $fw, 'Device::Firewall::PaloAlto', 'Device::Firewall::PaloAlto Object' );

done_testing();
