package WikipediaCorpus;

use v5.10;
use utf8;

use Moose;
use XML::SAX;
use WikipediaXMLHandler;

has 'filename' => (is => 'ro', isa => 'Str', required => 1);

sub name {
  return 'wikipedia'
}

sub parse {
    my $self = shift;
    my $document_callback = shift;
    my $end_callback = shift;

    my $title = "";
    my $parser = XML::SAX::ParserFactory->parser(
      Handler => new WikipediaXMLHandler(
        title_callback => sub {
          $title = shift;
        },
        article_callback => sub {
          my $text = $title . "\n" . MediaWikiFilter::filter(shift);
          $document_callback->($text);
        },
        end_callback => $end_callback
      )
    );

    open(my $fh, "<", $self->{filename});

    $parser->parse_file($fh);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
