use Test::More;

use Device::Firewall::PaloAlto;

my $fw = Device::Firewall::PaloAlto->new(uri => 'http://pa.localdomain', username => 'admin', password => 'admin');

ok( $fw->authenticate, 'authenticate()' );
ok( $fw->op->interfaces, 'interfaces()' );
ok( $fw->op->routes, 'routes()' );

done_testing();
