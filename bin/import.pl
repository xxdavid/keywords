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

binmode(STDOUT, ":utf8");

my $xmlFilename = $ARGV[0];
my $corpus = new WikipediaCorpus(filename => $xmlFilename);

my $importer = new Importer(corpus => $corpus);
$importer->start();
