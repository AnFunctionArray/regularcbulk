$isnested = 1;

use re 'eval';

use Data::Dumper;


BEGIN{push @INC, "./misc"};
BEGIN{push @INC, "./regexes/supplement"};

$filename = $ARGV[0];
open my $fh, '<', $filename or die "error opening $filename: $!";

my $subject = do { local $/; <$fh> };

close $fh;

$subject =~ s{::}{_}sg;


$filename = $ARGV[0] . "_out.pp";
open my $fh, '>', $filename or die "error opening $filename: $!";

print $fh $subject;

close $fh;

exit;