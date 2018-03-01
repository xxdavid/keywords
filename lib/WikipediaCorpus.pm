package WikipediaCorpus;

use v5.10;
use strict;
use warnings;
use utf8;

use Moose;
use XML::SAX;
use WikipediaXMLHandler;

has 'filename' => (is => 'ro', isa => 'Str');

sub parse {
    my $self = shift;
    my $documentHandler = shift;

    my $parser = XML::SAX::ParserFactory->parser(
      Handler => new WikipediaXMLHandler(callback => sub {
        my $text = MediaWikiFilter::filter(shift);
        $documentHandler->($text);
      })
    );

    open(my $fh, "<", $self->{filename});

    $parser->parse_file($fh);
}

1;
