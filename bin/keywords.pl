#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use utf8;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');

use KeywordExtractor;

binmode(STDOUT, ":utf8");

my $filename = $ARGV[0];
my $extractor = new KeywordExtractor(filename => $filename);
$extractor->extract;
