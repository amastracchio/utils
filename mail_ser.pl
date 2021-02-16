#!/usr/bin/perl

use IO::Socket;
use Data::Dumper;

use Net::Server::Mail::SMTP;


my $ttyter = "/root/3p/bin/ttyter.pl";
my $filetmp = "/tmp/pro.txt";

    printymail( "iniciando..\n");
    my @local_domains = qw(b701613 example.org);
    my $server = new IO::Socket::INET Listen => 1, LocalPort => 25;
    
    my $conn;
    while($conn = $server->accept)
    {
        my $smtp = new Net::Server::Mail::SMTP socket => $conn;
        $smtp->set_callback(RCPT => \&validate_recipient);
        $smtp->set_callback(DATA => \&queue_message);
        $smtp->process();
        $conn->close();
    }

    sub validate_recipient
    {
        my($session, $recipient) = @_;

        return 1;
        
# DESACTIVADO
#        my $domain;
#        if($recipient =~ /@(.*)>\s*$/)
#        {
#            $domain = $1;
#        }
#
#        if(not defined $domain)
#        {
#            return(0, 513, 'Syntax error.');
#        }
#        elsif(not(grep $domain eq $_, @local_domains))
#        {
#            return(0, 554, "$recipient: Recipient address rejected: Relay access denied");
#        }
#
#        return(1);
    }

    sub queue_message
    {
        my($session, $data) = @_;

        my $sender = $session->get_sender();
        my @recipients = $session->get_recipients();

        return(0, 554, 'Error: no valid recipients')
            unless(@recipients);
        
        my $msgid = add_queue($sender, \@recipients, $data);

        return(1, 250, "message queued $msgid");
    }



#####################
sub add_queue{
  my ($sender, $rec, $dat) = @_;

  printymail( "ADD QUEUE!! sender = $sender , rec = $rec dat = $dat\n");

  my $dest =  $$rec[0];

  my $ran = int(rand(10000));

#  my $file = "/cygdrive/c/mail/$sender"."_to_".$dest."_".$ran.".txt";
  my $file = "/mail/$sender"."_to_".$dest."_".$ran.".txt";

  $file =~ s/\@/_on_/g;
  $file =~ s/>//g;
  $file =~ s/<//g;

  print "file = $file\n";

  open(FILE, ">$file") || printymail( "error: $! \n");

  print  FILE $$dat;


  my $str = $$dat;

  print $str;
  $str =~ /Subject:(.+)$/ms;
  $str = $1;

  close(FILE);

  # Envio a twitter

  $str =~ s/\n/./g;
  $str =~ s/\r//g;

  $str =~ s/User-Agent: .*//;
  $str =~ s/MIME-Version: 1.0//;
  $str =~ s/Content-Type: .*//;
  $str =~ s/Content-Transfer-Encoding:.*//;


  $str = substr($str,0,137);
  $str .= "\n";



  print "Por ejecutar $ttyter $filetmp \n";
  open (PIPE , ">$filetmp");
  print PIPE $str;
  close( PIPE);

  system "$ttyter $filetmp";
  print "Salio.\n";

}



####################################
sub printymail {
my ($lin)  = @_;
my $fmail = "/grade/mail_serv.log";

open(MAILX,">>$fmail");
print MAILX $lin;
print $lin;
close(MAILX);

}



