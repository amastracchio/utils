

use IO::Socket;

my $sock = new IO::Socket::INET (
 LocalHost => 'localhost',
 LocalPort => '10000',
 Proto => 'tcp',
 Listen => 1,
 Reuse => 1,
 );

 die "Could not create socket: $!\n" unless $sock;

 my $msg = "HTTP/1.1 401 Authorization Required\r\nDate: Tue, 08 Jan 2013 18:03:16 GMT\r\nServer: Apache\r\nWWW-Authenticate: Basic realm=\"Ingrese usuario y password\"\r\nAccept-Encoding\r\nContent-Encoding: gzip\r\nContent-Length: 353\r\nKeep-Alive: timeout=2,max=100\r\nConnection: Keep-Alive\r\nContent-Type: text/html; charset=iso-8859-1\r\n";

 my $new_sock = $sock->accept();


 while(my $lin = <$new_sock>) {

  print $lin;

  if ($lin =~ /Connection/m) {
 	print $new_sock $msg;
#	last;
  }

  }


 close($sock);

