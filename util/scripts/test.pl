
my $num_args = $#ARGV + 1;
if ($num_args % 2 == 0){
    print "Missing some command line arguments. Try again!";
    exit;
}

my %hash = @ARGV;
@names = keys %hash;
system("mkdir flows");
system("mkdir rec");
system("mkdir logs");
for(my $i  = 1; $i <= $hash{-NR}; $i++){
    my $seed = int(rand(1000000000));
    $random = "randomfield -Nx $hash{-Nx} -Ny $hash{-Ny} -Nz $hash{-Nz} -a $hash{-a} -g $hash{-g} -sd $seed random$i.ff";
    print "Random Field $i generated\n";
    print $random;
    print "\n";
    system($random);
    $couette = "couette -T0 $hash{-T0} -T1 $hash{-T1} -dT $hash{-dT} -symms $hash{-symms} -o flows/flow$i/ -l2 random$i.ff > logs/flow$i.log 2>&1";
    print $couette;
    print "\n";
    system($couette);
    
    print "Field $i integrated forward in time\n";
    
    $recurrence = "~/Varchas/Git/utils/bin/recurrence.x -T0 $hash{-T0} -T1 $hash{-TR1} -TR $hash{-TR} -dT $hash{-dT} -d flows/flow$i/ rec/rec$i > logs/rec$i.log 2>&1";
    print $recurrence;
    print "\n";
    system($recurrence);
}
system("mv *.csv rec");
