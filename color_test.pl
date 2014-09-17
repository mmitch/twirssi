#!/usr/bin/perl -w
#
# QUICK HORRIBLE HACK!
#
# enter nicknames as optional parameters
#

use strict;

my %mirc_to_ansi_fg = 
(
    '0'  => '1;37',
    '1'  => '30',
    '2'  => '34',
    '3'  => '32',
    '4'  => '1;31',
    '5'  => '31',
    '6'  => '35',
    '7'  => '33',
    '8'  => '1;33',
    '9'  => '1;32',
    '10' => '36',
    '11' => '1;36',
    '12' => '1;34',
    '13' => '1;35',
    '14' => '1;30',
    '15' => '37'
);

my %mirc_to_ansi_bg = 
(
    '0'  => '5;47',
    '1'  => '40',
    '2'  => '44',
    '3'  => '42',
    '4'  => '5;41',
    '5'  => '41',
    '6'  => '45',
    '7'  => '43',
    '8'  => '5;43',
    '9'  => '5;42',
    '10' => '46',
    '11' => '5;46',
    '12' => '5;44',
    '13' => '5;45',
    '14' => '5;40',
    '15' => '47'
);



my @available_nick_colors;

open TWIRSSI, '<', 'twirssi.pl' or die $!;

my $line;

while ($line = <TWIRSSI>)
{
    last if $line =~ /my \@available_nick_colors =/;
}
$line =~ s/^my //;
my $code = $line;

while ($line = <TWIRSSI>)
{
    $code .= $line;
    last if $line =~ /\);/;
}

close TWIRSSI;

eval $code;

sub colorize($$)
{
    my ($text, $color) = (@_);
    my ($fg, $bg) = ('', '');
    my @c = split /,/, $color;
    
    if (defined $c[0])
    {
	$fg = "\033[".$mirc_to_ansi_fg{$c[0]}."m";
    }
    
    if (defined $c[1])
    {
	$bg = "\033[".$mirc_to_ansi_bg{$c[1]}."m";
    }

    return "${fg}${bg}${text}\033[0m\033[40m";
}

foreach my $color (@available_nick_colors)
{
    print "  $color = " . colorize(" *** $color *** ", $color). "  ";
}

print " T H E     E N D ";
print "\n";


foreach my $arg (@ARGV)
{
    my @chars = split //, lc $arg;
    my $value = 0;
    foreach my $char (@chars) {
	$value += ord $char;
    }
    my $color = $available_nick_colors[$value % @available_nick_colors];
    
    print "nick $arg will be color $color and look like this: ".colorize($arg, $color)."\n";
}
