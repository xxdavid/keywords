# Keywords
A keyword extraction program based on TF-IDF method.

The focus is on the Czech language and therefore it uses Czech Wikipedia as corpus.

## Requirements
This project requires external modules from CPAN. Install them with:
```bash
cpan DBD::SQLite XML::SAX Moose Getopt::Long::Descriptive
```

## Usage
To analyze a text, just run `bin/keywords.pl` inside the project directory with parameters
* `--file` / `-f`: path to the text file to analyze
* `--corpus-name` / `-c`: either `wikipedia` or `wikipedia-titles`
* `--limit` / `-l`: number of keywords to list (defaults to 10)
* `--with-scores` / `-s`: include keyword scores in the list (defaults to false)

You can also create the database yourself with scripts `bin/init-db.pl` and `bin/import.pl`. Run them without any parameter to display the help message.
