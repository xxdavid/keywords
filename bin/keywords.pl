#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use utf8;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');

use KeywordExtractor;
use Getopt::Long::Descriptive;

binmode(STDOUT, ":utf8");

my ($opt, $usage) = describe_options(
    '%c %o',
    [ 'file|f=s', "the file to analyze",   { required => 1 } ],
    [ 'corpus-name|c=s', "the name of the corpus you want to use", { default => 'wikipedia' } ],
    [ 'limit|l=i', "number of keywords to list", { default => 10 } ],
    [ 'with-scores|s', "include keyword scores in the list", { default => 0 } ],
    [ 'help', "print this message", { shortcircuit => 1 } ],
  );

die "Provided corpus name is not correct, valid options are: [wikipedia, wikipedia-titles]."
  unless ($opt->corpus_name eq "wikipedia" || $opt->corpus_name eq "wikipedia-titles");

print($usage->text), exit if $opt->help;

my $extractor = new KeywordExtractor(filename => $opt->file, limit => $opt->limit,
  corpus_name => $opt->corpus_name, show_scores => $opt->with_scores);
$extractor->extract;
