#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use utf8;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');

use Importer;
use WikipediaCorpus;
use WikipediaTitlesCorpus;
use Getopt::Long::Descriptive;

binmode(STDOUT, ":utf8");

my ($opt, $usage) = describe_options(
    '%c %o',
    [ 'corpus-name|c=s', "the name of the corpus you want to import", { required => 1 } ],
    [ 'file|f=s', "the file to import from",   { required => 1 } ],
    [ 'help', "print this message", { shortcircuit => 1 } ],
  );

print($usage->text), exit if $opt->help;

my $corpus;
if ($opt->corpus_name eq 'wikipedia') {
  $corpus = new WikipediaCorpus(filename => $opt->file);
} elsif ($opt->corpus_name eq 'wikipedia-titles') {
  $corpus = new WikipediaTitlesCorpus(filename => $opt->file);
} else {
  $! = 1;
  die "Provided corpus name is not correct, valid options are: [wikipedia, wikipedia-titles].";
}

my $importer = new Importer(corpus => $corpus);
$importer->start();
