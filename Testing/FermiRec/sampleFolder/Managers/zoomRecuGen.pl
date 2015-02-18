$parfile = "recurrenceZoom.param";
$executable = "recurrence.x";

my %keyval;
open(PF,"../Parameters/$parfile") or die "Cannot find file";
while(<PF>){
    chomp;
    my ($key,$value) = split(' ',$_);
    $keyval{$key} = $value;
}
close(PF);
$parString = join(" ", map {"$_ $keyval{$_}"} keys %keyval);
$execString = "$executable $parString > ../logs/recurrence.logs";
print "$execString\n";
system($execString);
