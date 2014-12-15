use Data::Dumper;


my %randpar;
my %couepar;
my %recupar;
my @dirList;
open(FRA, "randpar.param") or die $!;
open(FCO, "couepar.param") or die $!;
open(FRE, "recupar.param") or die $!;
while(<FRA>) {
    chomp;
    my ($key,$value) = split(' ',$_);
    $randpar{$key} = $value;
}

while(<FCO>) {
    chomp;
    my ($key,$value) = split(' ',$_);
    $couepar{$key} = $value;
}

while(<FRE>) {
    chomp;
    my ($key,$value) = split(' ',$_);
    $recupar{$key} = $value;
}
close(FRA);
close(FCO);
close(FRE);
my $directory = './';
opendir(DIR, $directory) or die $!;
while(my $subdir = readdir(DIR)){
    if($subdir =~ /random(\d)+/){
	push(@dirList,$subdir);
    }
}
@commands;
my $randparstr = join(" ",map { "$_ $randpar{$_}" } keys %randpar);
my $coueparstr = join(" ",map { "$_ $couepar{$_}" } keys %couepar);
my $recuparstr = join(" ",map { "$_ $recupar{$_}" } keys %recupar);


foreach $randDir (@dirList){
    my $pid;
    next if $pid = fork;
    die "fork failed: $!" unless defined $pid;
    system("mkdir $randDir/log");
    system("randomfield $randparstr $randDir/$randDir > $randDir/log/rand.log");
    system("couette $coueparstr -o $randDir/d$randDir -l2 $randDir/$randDir > $randDir/log/couette.log");
    system("recurrence.x $recuparstr -d $randDir/d$randDir $randDir/r$randDir > $randDir/log/rec.log");
    exit;
    
}
1 while (wait() != -1);

print "All done!\n";
print "$randparstr\n";
print "$coueparstr\n";
print "$recuparstr\n";
