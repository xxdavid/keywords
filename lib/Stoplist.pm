package Stoplist;

use v5.10;
use utf8;

use Moose;

my %stoplist = ();

sub BUILD {
  my $self = shift;

  my $filename = "data/stoplist.txt";
  open(my $fh, '<:encoding(UTF-8)', $filename);
  while (my $word = <$fh>) {
    chomp $word;
    $stoplist{$word} = 1;
  }
}


sub is_stoplisted {
  my $self = shift;
  my $word = shift;
  return exists $stoplist{$word};
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
