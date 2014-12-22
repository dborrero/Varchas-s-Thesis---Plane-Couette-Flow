@dirList;

my $directory = './';
opendir(DIR, $directory) or die $!;
while(my $subdir = readdir(DIR)){
    if($subdir =~ /random(\d)+/){
	push(@dirList,$subdir);
    }
}

foreach $randDir (@dirList){
    next if $pid = fork;
    die "fork failed: $!" unless defined $pid;
    print "Beginning in $randDir\n";
    chdir('$randDir/Managers');
    system("perl master.pl");
    exit;
    
}
1 while (wait() != -1);

