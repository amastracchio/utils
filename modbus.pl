use Data::Dumper;
use Device::Modbus::RTU::Client;
use strict;
use warnings;
use v5.10;
use Getopt::Long;

my $oper;
my $dev;
my $relay;

#GetOptions ("o=s" => \$oper,    # numeric
#             "d=s"   => \$dev,      # string
#             "r=s"  => \$relay)   # flag
#    or die("Error in command line arguments\n");
#
#
#die $oper;

 
my $client = Device::Modbus::RTU::Client->new(
   port     => '/dev/ttyUSB0',
   baudrate => 9600,
   parity   => 'none',
);

 
#my $req = $client->read_holding_registers(
#   unit     => 247,
#   address  => 1,
#   quantity => 3,
#);

 my $req = Device::Modbus::Request->new(
        function => 'Write Single Coil',
#        function => 'Read Coils',
        address  => 0,
	unit   => 1,
        value    =>255 ,
   quantity => 1
    );

print Dumper $req;

 
my $pdu = $req->pdu;
my $pdu_array = unpack('H*', $pdu);

print $pdu_array;



print length($pdu);



print Dumper $req;
$client->send_request($req);
my $resp = $client->receive_response;



die Dumper $resp;

#    my $request = Device::Modbus::Request->new(
#        function => 'Write Single Coil',
#        address  => 172,
#        value    => 'A'
#    );
#
#    isa_ok $request, 'Device::Modbus::Request';
#    is $request->{code}, 0x05,
#        'Function code 0x05 returned correctly';
#
#    my $pdu = $request->pdu;
#    my $pdu_string = unpack('H*', $pdu);
#    print "PDU = $pdu_string\n";

