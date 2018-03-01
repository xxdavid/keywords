package Importer;

use v5.10;
use utf8;

use Moose;

has 'corpus' => (is => 'ro');

sub start {
  my $self = shift;

  my $handleDocument = sub
  {
    my $document = shift;

    while ($document =~ /((?!\d)\w+)/gu) {
        say lc $1;
    }
  };

  $self->{corpus}->parse($handleDocument);
}

1;
