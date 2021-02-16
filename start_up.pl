#!/usr/bin/perl


# Recibe como parametrospor ejemplo
# param 1=CRITICAL param2=HARD pram3=3 param4=/users/login/bampfri/3p/cf/sbin/cf-execd param5=get pa
# dodne param1 -> estado
#       param2 -> SOFT o HARD
#       param3 -> # de intento
#       param4 -> comando a matchera!!!! (en ps si no no corre)
#       param5 -> comando a ejecutar
#   tomar en cuenta el resto de los parametros porque el espacio es como uno mas


my $ps = "ps -ef|";
my $yacorre;
my $ret;


# se para en toro directorio
chdir($ENV{HOME}."/3p/bin");

open (FILE, ">>/tmp/start_up.log");

my $time = scalar localtime;       

my $cmd = join(" ",@ARGV[4..9]) .' >/tmp/start_up.log1 2>/tmp/start_up.log.err1 &';
my $a_matchear = $ARGV[3];
my $yacorre;

print FILE "Llamo $time status= $ARGV[0] SOFT/HARD=$ARGV[1] #intento=$ARGV[2] programa=$ARGV[3] etc=$ARGV[4] param6=$ARGV[5]\n";
print FILE "Por ejecutar= $cmd \n";
print FILE "A matchear= $a_matchear \n";


unless ($ARGV[0] =~ /OK/) {

  open(PS, $ps);

  while (<PS>) {

	if ((/$a_matchear/)  && !(/start_up/) ){
		$yacorre = 1;
		print FILE "Matcheo tabla de procesos=$_\n";
	}
  }

  close (PS);


  if (!$yacorre) {

    $ret = system($cmd);
    print FILE "No esta corriente se ejecutaresult= $ret \n";

  } else {

    print FILE "Ya estaba corriendo. \n";
	
  }


} else {
  print FILE "Es OK nada para ejecutar.fin \n";
}



close FILE;

