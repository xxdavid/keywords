package Database;

use v5.10;
use utf8;

use Moose;
use DBI qw(:sql_types);

my $db_filename = "database.sqlite3";
my $db = DBI->connect("dbi:SQLite:dbname=$db_filename","","");
my $table = "words";

sub increment {
  my $self = shift;
  my $ref = shift;

  $db->{AutoCommit} = 0;
  my $i = 0;
  foreach my $word (keys %$ref) {
    my $count = $ref->{$word};

    my $sth = $db->prepare("INSERT OR IGNORE INTO words (word, count) VALUES (?, 0)");
    $sth->bind_param(1, $word);
    $sth->execute;

    my $sth2 = $db->prepare("UPDATE words SET count = count + ? WHERE word = ?");
    $sth2->bind_param(1, $count, SQL_INTEGER);
    $sth2->bind_param(2, $word);
    $sth2->execute;

    $i++;
  }
  $db->commit;
  $db->{AutoCommit} = 1;
}
