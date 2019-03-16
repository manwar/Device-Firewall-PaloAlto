use Test::More;
use Device::Firewall::PaloAlto;

my $fw = Device::Firewall::PaloAlto->new(ssl_opts => { verify_hostname => 0 })->auth;
my $arp_table = $fw->op->arp_table;

ok( $arp_table, "ARP Table" );
like( $arp_table->current_entries, qr(\d+), "ARP Entries" );
like( $arp_table->max_entries, qr(\d+), "ARP Entries" );

my @arp_entries = $arp_table->to_array();

for my $arp_entry (@arp_entries) {
    isa_ok( $arp_entry, 'Device::Firewall::PaloAlto::Op::ARPEntry', 'ARP Entry object' );

    # Check the MAC address
    like( $arp_entry->mac, qr{ ([0-9a-f]{2}) (:[0-9a-f]{2}){5} }xms, 'MAC Address' );
    like( $arp_entry->status, qr{static|complete|expiring|incomplete}, "MAC Status" );
}
    



## EMPTY TABLE

my $empty_tbl_api = {
    result => {
        dp => "dp0",
        entries => {},
        max => 250,
        timeout => 1800,
        total => 0
    },
    status => "success"
};
    





done_testing();
