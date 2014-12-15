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
    next if $pid = fork;
    die "fork failed: $!" unless defined $pid;
    my @array = split('m',$randDir);
    srand();
    my $seed = int(rand(3000000000));
    system("mkdir $randDir/log");
    my $randExec = "randomfield $randparstr -sd $seed $randDir/random.ff > $randDir/log/rand.log";
    print "$randExec\n";
    system($randExec);
    my $coueExec = "couette $coueparstr -o $randDir/data -l2 $randDir/random.ff > $randDir/log/couette.log";
    print "$coueExec\n";
    system($coueExec);
    system("recurrence.x $recuparstr -d $randDir/data $randDir/rec > $randDir/log/rec.log");
    exit;
    
}
1 while (wait() != -1);

print "All done!\n";
print "$randparstr\n";
print "$coueparstr\n";
print "$recuparstr\n";
