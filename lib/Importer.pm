package Importer;

use v5.10;
use utf8;

use Moose;
use Database;

has 'corpus' => (is => 'ro', required => 1);

my %current_words = ();
my %frequencies = ();

my $source = 'wikipedia';
my $db = new Database(source => $source);
my $words_threshold = 100000;

sub start {
  my $self = shift;

  my $document_count = 0;

  my $save = sub {
        print "Saving... ";
        select()->flush();
        $db->increment(\%frequencies, $document_count);
        print "Done.\n";
  };

  my $handle_document = sub
  {
    my $document = shift;
    %current_words = ();

    while ($document =~ /((?!\d)\w+)/gu) {
      my $word = lc $1;

      unless (exists $current_words{$word}) {
        $frequencies{$word}++;
        $current_words{$word} = 1;

        if (keys %frequencies >= $words_threshold) {
          $save->();
          %frequencies = ();
        }
      }
    }


    $document_count++;
    if ($document_count % 1000 == 0) {
      say "$document_count documents processed.";
    }
  };

  my $handle_end = sub {
    $save->();
  };

  say "Starting the import of '$source'.";

  $self->{corpus}->parse($handle_document);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
