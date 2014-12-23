$parfile = "random.param";
$executable = "randomfield";

my %keyval;
open(PF,"../Parameters/$parfile") or die "Cannot find file";
while(<PF>){
    chomp;
    my ($key,$value) = split(' ',$_);
    $keyval{$key} = $value;
}
close(PF);
srand();
$seed = int(rand(30000000));
$parString = join(" ", map {"$_ $keyval{$_}"} keys %keyval);
$execString = "$executable $parString -sd $seed ../random.ff > ../logs/random.log";
print "$execString\n";
system($execString);