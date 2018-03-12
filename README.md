# Keywords
A keyword extraction program based on TF-IDF method.

The focus is on the Czech language and therefore it uses Czech Wikipedia as corpus.

## Requirements
This project requires external modules from CPAN. Install them with:
```bash
cpan DBD::SQLite XML::SAX Moose Getopt::Long::Descriptive
```

## Getting the database
If you have download this project from GitHub, you'll also need to download the database (as GitHub doesn't alllow files larger than 100 MB to be part of the repo). Download it from [here](https://github.com/xxdavid/keywords/releases/download/1.0/database.sqlite3) and place it into the *data* folder.

## Usage
To analyze a text, just run `bin/keywords.pl` inside the project directory with parameters
* `--file` / `-f`: path to the text file to analyze
* `--corpus-name` / `-c`: either `wikipedia` or `wikipedia-titles`
* `--limit` / `-l`: number of keywords to list (defaults to 10)
* `--with-scores` / `-s`: include keyword scores in the list (defaults to false)

You can also create the database yourself with scripts `bin/init-db.pl` and `bin/import.pl`. Run them without any parameter to display the help message.
