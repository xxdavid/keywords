#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use utf8;

use FindBin;
use File::Spec;
use lib File::Spec->catdir($FindBin::Bin, '..', 'lib');

use WikipediaCorpus;

binmode(STDOUT, ":utf8");

my $xmlFilename = $ARGV[0];

my $corpus = WikipediaCorpus->new(filename => $xmlFilename);

my $handleDocument = sub
{
  my $document = shift;

  while ($document =~ /((?!\d)\w+)/gu) {
      say lc $1;
  }
};

$corpus->parse($handleDocument);
