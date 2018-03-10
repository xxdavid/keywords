package Importer;

use v5.10;
use utf8;

use Moose;
use Database;

has 'corpus' => (is => 'ro');

my %current_words = ();
my %frequencies = ();

my $source = 'wikipedia';
my $db = new Database(source => $source);
my $articles_threshold = 1000;

sub start {
  my $self = shift;

  my $document_count = 0;
  my $handle_document = sub
  {
    my $document = shift;
    %current_words = ();

    while ($document =~ /((?!\d)\w+)/gu) {
      my $word = lc $1;

      unless (exists $current_words{$word}) {
        $frequencies{$word}++;
        $current_words{$word} = 1;
      }
    }


    $document_count++;
    if ($document_count % $articles_threshold == 0) {
      say "$document_count  articles (" . scalar(%frequencies) . " words in hash)";
      print "Saving... \n";
      $db->increment(\%frequencies, $document_count);
      print "Done.\n";
      %frequencies = ();
    }
  };

  my $handle_end = sub {
    db->increment(\%frequencies, $document_count);
  };

  $self->{corpus}->parse($handle_document);
}

1;
