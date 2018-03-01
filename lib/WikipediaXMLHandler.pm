package WikipediaXMLHandler;

use v5.10;
use utf8;

use Moose;
use MediaWikiFilter;

has 'callback' => (is => 'ro');

my $tag_name;
my $in_page = 0;
my $content = "";

sub start_element {
  my ($self, $el) = @_;

  $tag_name = $el->{Name};

  if ($el->{Name} eq "page") {
    $in_page = 1;
  } elsif ($el->{Name} eq "redirect") {
    $in_page = 0;
  }

}

sub end_element {
  my ($self, $el) = @_;

  if ($el->{Name} eq "page") {
    $self->{callback}($content);

    $in_page = 0;
    $content = "";
  }
}

sub characters {
    my ($self, $el) = @_;

    if ($in_page) {
      if ($tag_name eq "text")  {
          $content .= $el->{Data};
      } elsif ($tag_name eq "title") {
          $content .= $el->{Data} . "\n";
      }
    }
}

1;
