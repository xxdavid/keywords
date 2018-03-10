package KeywordExtractor;

use v5.10;
use utf8;

use Moose;
use Database;
use Stoplist;

has 'filename'  => (is => 'ro', isa => 'Str', required => 1);
has 'corpus_name'  => (is => 'ro', isa => 'Str', required => 1);
has 'limit'  => (is => 'ro', isa => 'Int', required => 1);
has 'show_scores'  => (is => 'ro', isa => 'Bool', required => 1);

sub extract {
  my $self = shift;
  my $stoplist = new Stoplist;

  open(my $fh, '<:encoding(UTF-8)', $self->{filename}) or die "Could not open file!";

  my $db = new Database(source => $self->{corpus_name});

  my $average_word_count = $db->get_average_count;
  my $number_of_documents = $db->get_document_count;

  my %frequencies = ();
  my $number_of_words = 0;
  my %scores = ();

  while (my $row = <$fh>) {
    while ($row =~ /((?!\d)\w+)/gu) {
      my $word = lc $1;

      next if Stoplist->is_stoplisted($word);

      $frequencies{$word}++;
      $number_of_words++;
    }
  }


  foreach my $word (keys %frequencies) {
    my $document_count = $frequencies{$word};
    my $tf = $document_count / $number_of_words;

    my $corpus_count = $db->get_count($word);
    $corpus_count = $average_word_count if not $corpus_count;
    my $idf = log($number_of_documents / $corpus_count);

    my $tf_idf = $tf * $idf;

    $scores{$word} = $tf_idf;
  }

  my $i;
  foreach my $word (reverse sort { $scores{$a} <=> $scores{$b} } keys %scores) {
    if ($self->{show_scores}) {
      # say "$word: $scores{$word}";
      printf "%-15s (%.3f)\n", $word, $scores{$word};
    } else {
      say "$word";
    }
    $i++;
    last unless $i < $self->{limit};
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
