$channelDir = "~/Varchas/channelflow/trunk"
$parfile = "multicouette.param";
$executable = "$channelDir/programs/couette";

$parfile2 = "perturb.param";
$executable2 = "$channelDir/programs/perturbfield";

 
my %keyval;
open(PF,"../Parameters/$parfile") or die "Cannot find file";
while(<PF>){
    chomp;
    my ($key,$value) = split(' ',$_);
    $keyval{$key} = $value;
}
close(PF);

 
my %keyval2;
open(PF2,"../Parameters/$parfile2") or die "Cannot find file";
while(<PF2>){
    chomp;
    my ($key2,$value2) = split(' ',$_);
    $keyval2{$key2} = $value2;
}
close(PF2);

for(my $i = 0; $i < 50; $i++){

srand();
$seed = int(rand(30000000));
$parString2 = join(" ", map {"$_ $keyval2{$_}"} keys %keyval2);
$execString2 = "$executable2 $parString2 -sd $seed ../Parameters/unperturbed.ff ../perturb$i.ff > ../logs/perturb$i.log";
print "$execString2\n";
system($execString2);

$parString = join(" ", map {"$_ $keyval{$_}"} keys %keyval);
$execString = "$executable $parString -l2 -o ../data$i ../perturb$i.ff > ../logs/couette$i.log";
print "$execString\n";
system($execString);
}
