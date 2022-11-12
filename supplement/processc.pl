$isnested = 1;

use re 'eval';

use Data::Dumper;


BEGIN{push @INC, "./misc"};
BEGIN{push @INC, "./regexes/supplement"};

$filename = $ARGV[0];
open my $fh, '<', $filename or die "error opening $filename: $!";

my $subject = do { local $/; <$fh> };

close $fh;

my $out;

my $outc;

my $lastalabl;

while ($subject =~ m{^
        ((?<base>[a-f0-9]{8})\s++
        (
            (?<rawbytes>[a-f0-9]++)\s+(?!(?&unknw))
        (
            (?!addr\b)
            (
                \?\?
                |
                (?<type>(?!\?\?\s)\S++)
            )
                \s++
                (
                    (?!addr\b)(?<val>[A-F0-9]++)(?<hex>h?+)
                    |
                    (?<valstr>".*")
                )
                |
                addr\s++([^:;\s]++:)?+(?<addressee>\S++)
        )
            |
            (
                (?<unknwb>\?\?)
                |
                (?!\?\?\s)(?<unknwty>\S++)
            )
            (?<unknw>\s++\?\? )
        )
            |
            \s++(?<lbl>[^:;\s]++):\p{Blank}*+$
            |
            \s*+;
        )
}mxxg) {
    $out .= ".p2align 0x" . $+{base} . "\n" if (exists $+{base});
    if (defined $lastalabl) {
        my $ty = $+{unknwty} // $+{type};
        my $istr = exists $+{valstr};

        if ($istr) {
            $outc .= "extern char " . $lastalabl . "[1];\n"
        }
        else {
            $ty //= "unsigned char";
            $outc .= "extern " . $ty . " " . $lastalabl . ";\n"
        }
        undef $lastalabl
    }
    if (exists $+{lbl}) {
        my $lbl = $+{lbl};

        $lbl =~ s{\W}{_}g;

        $out .= ".global " . $lbl . "\n";

        $out .= "\t" . $lbl . ":" . "\n";

        $lastalabl = $lbl;
    }
    elsif (exists $+{addressee}) {
        my $nm = $+{addressee};

        $nm =~ s{\W}{_}g;

        $out .= ".long " . $nm  . "\n"; 
    }
    elsif (exists $+{rawbytes}) {
        my $raw = $+{rawbytes};

        my $tmp;

        while ($raw =~ m{[a-f0-9]{2}}g) {
            $tmp .= ($tmp && ",") . "0x" . $&;
        }

        $out .= ".byte " . $tmp . "\n";
    }
}



$filename = $ARGV[0] . "_out.s";
open my $fh, '>', $filename or die "error opening $filename: $!";

print $fh $out;

close $fh;

$filename = $ARGV[0] . "_out.pp";
open my $fh, '>', $filename or die "error opening $filename: $!";

print $fh $outc;

close $fh;


exit;