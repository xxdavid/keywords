package Database;

use v5.10;
use utf8;

use Moose;
use DBI qw(:sql_types);
use File::Basename;

my $dirname = dirname(__FILE__);
my $db_filename = "$dirname/../data/database.sqlite3";
my $db = DBI->connect("dbi:SQLite:dbname=$db_filename","","");
$db->do("PRAGMA foreign_keys = ON");

has 'source' => (is => 'ro', isa => 'Str', required => 1);
has 'create_source_if_needed' => (is => 'ro', isa => 'Bool', default => 0);

sub BUILD {
  my $self = shift;

  if ($self->{create_source_if_needed}) {
    my $sth_insert = $db->prepare("INSERT OR IGNORE INTO sources (name, doument_count) VALUES (?, 0)");
    $sth_insert->bind_param(1, $self->{source});
    $sth_insert->execute;
  }

  my $sth_select = $db->prepare("SELECT id FROM sources WHERE name = ?");
  $sth_select->bind_param(1, $self->{source});
  $sth_select->execute;
  my $row_select = $sth_select->fetch;
  my $source_id = $row_select->[0];

  if (!defined $source_id) {
    my $source_name = $self->{source};
    die "Source '$source_name' has not been imported.";
  }

  $self->{source_id} = $source_id;
}

sub init {
  my $query_sources = <<"EOF";
CREATE TABLE IF NOT EXISTS sources (
  id integer PRIMARY KEY,
  name text NOT NULL,
  doument_count integer
);
EOF
  my $sth_sources = $db->prepare($query_sources);
  $sth_sources->execute;

  my $query_words = <<"EOF";
CREATE TABLE IF NOT EXISTS words (
  word text NOT NULL,
  count integer,
  source_id integer NOT NULL,
  FOREIGN KEY (source_id) REFERENCES sources(id),
  UNIQUE(word, source_id)
);
EOF
  my $sth_words = $db->prepare($query_words);
  $sth_words->execute;

  my $sth_words_index = $db->prepare("CREATE INDEX IF NOT EXISTS idx_words ON words(word)");
  $sth_words_index->execute;

  my $sth_sources_index = $db->prepare("CREATE UNIQUE INDEX IF NOT EXISTS idx_sources ON sources(name)");
  $sth_sources_index->execute;
}

sub increment {
  my $self = shift;
  my $frequencies_ref = shift;
  my $document_count = shift; # sum, not difference

  $db->{AutoCommit} = 0;
  my $i = 0;
  foreach my $word (keys %$frequencies_ref) {
    my $count = $frequencies_ref->{$word};

    my $sth_insert = $db->prepare("INSERT OR IGNORE INTO words (word, count, source_id) VALUES (?, 0, ?)");
    $sth_insert->bind_param(1, $word);
    $sth_insert->bind_param(2, $self->{source_id}, SQL_INTEGER);
    $sth_insert->execute;

    my $sth_update = $db->prepare("UPDATE words SET count = count + ? WHERE word = ? AND source_id = ?");
    $sth_update->bind_param(1, $count, SQL_INTEGER);
    $sth_update->bind_param(2, $word);
    $sth_update->bind_param(3, $self->{source_id}, SQL_INTEGER);
    $sth_update->execute;

    $i++;
  }

  my $sth_documents = $db->prepare("UPDATE sources SET doument_count = ? WHERE name = ?");
  $sth_documents->bind_param(1, $document_count, SQL_INTEGER);
  $sth_documents->bind_param(2, $self->{source});
  $sth_documents->execute;

  $db->commit;
  $db->{AutoCommit} = 1;
}

sub get_count {
  my $self = shift;
  my $word = shift;

  my $sth = $db->prepare("SELECT count FROM words WHERE word = ? AND source_id = ? LIMIT 1");
  $sth->bind_param(1, $word);
  $sth->bind_param(2, $self->{source_id});
  $sth->execute;
  my $row = $sth->fetch;
  return $row->[0];
}

sub get_average_count {
  my $self = shift;

  my $sth = $db->prepare("SELECT avg(count) FROM words WHERE source_id = ?");
  $sth->bind_param(1, $self->{source_id});
  $sth->execute;
  my $row = $sth->fetch;
  return $row->[0];
}

sub get_document_count {
  my $self = shift;

  my $sth = $db->prepare("SELECT doument_count FROM sources WHERE name = ? LIMIT 1");
  $sth->bind_param(1, $self->{source});
  $sth->execute;
  my $row = $sth->fetch;
  return $row->[0];
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
