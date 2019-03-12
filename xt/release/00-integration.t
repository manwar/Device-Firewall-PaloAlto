use Test::More;

use Device::Firewall::PaloAlto;

my $fw = Device::Firewall::PaloAlto->new(uri => 'http://pa.localdomain', username => 'admin', password => 'admin');

done_testing();
