use Test::More;
use Device::Firewall::PaloAlto;

my $fw = Device::Firewall::PaloAlto->new(ssl_opts => { verify_hostname => 0 })->auth;
my $default_vr = $fw->op->virtual_router();
my $guest_vr = $fw->op->virtual_router('guest');

isa_ok($default_vr, 'Device::Firewall::PaloAlto::Op::VirtualRouter');
isa_ok($guest_vr, 'Device::Firewall::PaloAlto::Op::VirtualRouter');


done_testing();
