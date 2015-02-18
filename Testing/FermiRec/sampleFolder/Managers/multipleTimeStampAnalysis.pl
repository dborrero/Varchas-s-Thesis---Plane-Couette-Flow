use File::ReadBackwards;
use Data::Dump; 

my @logList;
my $bw;
my $outputString;
my @output;
my$time;
my $thresholdTime = $ARGV[0];

my @finishedLog;
my $directory = '../logs';
opendir(DIR, $directory) or die $!;
while(my $logfile = readdir(DIR)){
    if($logfile =~ /couette(\d)+/){
        push(@logList,$logfile);
    }
}

foreach $logFile (@logList){

    $bw = File::ReadBackwards->new("../logs/$logFile") or 
	die "Can't read log file $!";

    $bw -> readline; 
    $outputString = $bw->readline;
    @outputArray = split(' ',$outputString);
    $time = $outputArray[6];

    if($time > ($thresholdTime-1)){
	push(@finishedLog,$logFile);
    }
}

print "Runs that ran for at least $thresholdTime time units:\n";
print join(", ", @finishedLog);
print "\n";
