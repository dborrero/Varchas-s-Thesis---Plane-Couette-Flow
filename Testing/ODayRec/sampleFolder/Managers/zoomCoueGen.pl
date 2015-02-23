$parfile = "couetteZoom.param";
$executable = "couette";

my %keyval;
open(PF,"../Parameters/$parfile") or die "Cannot find file";
while(<PF>){
    chomp;
    my ($key,$value) = split(' ',$_);
    $keyval{$key} = $value;
}
close(PF);

$parString = join(" ", map {"$_ $keyval{$_}"} keys %keyval);
$execString = "$executable -l2 -o ../data $parString > ../logs/couette.log";
print "$execString\n";
system($execString);
