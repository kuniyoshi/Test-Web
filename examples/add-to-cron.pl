#!/usr/bin/perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use Path::Class qw( file );
use Time::Seconds qw( ONE_MINUTE );
use TAP::Harness;

use constant MAX_INTERVAL => 30 * ONE_MINUTE;

my @files = @ARGV;

die "usage: $0 <files>"
    unless @files;

sleep MAX_INTERVAL * rand;

my $filename = "/tmp/tap.out";
my $file     = file( $filename );
my $FH       = $file->open( ">:encoding(utf-8)" )
    or die "open($filename): $!";

my $harness = TAP::Harness->new( {
    lib       => [ "lib" ],
    merge     => 1,
    verbosity => 1,
    stdout    => $FH,
} );

$harness->runtests( \@files );
my $res = $?;

close $FH
    or die "close($filename): $!";

exit
    if $res == 0;

warn $file->slurp;

