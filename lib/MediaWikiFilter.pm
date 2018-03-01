package MediaWikiFilter;

use v5.10;
use utf8;

sub filter {
    my ($text) = @_;

    $text =~ s/\{\{([^{}]|(?R))*\}\}//g; # {{ teplates (using recursion) }}
    $text =~ s/\[\[(?:[\w ():]+\|)?([\w ]+)\]\]/$1/gu; # [[links]]
    $text =~ s/\[\[([^\[\]]|(?R))*\]\]//g; # [[links-like garbage]]
    $text =~ s/\{\|([^{}]|(?R))*\|\}//g; # {| tables (recursive) |}
    $text =~ s/\{\|(.|\n)*?\|\}//g; # {| tables (needs to be done twice because the first one fails on sub {{x}} and there is no quick fix to that) |}
    $text =~ s/={2,6}(.*?)={2,6}/$1/g; # == Title ==
    $text =~ s/'{2,5}(.*?)'{2,5}/$1/g; # ''italic'' and '''bold'''
    $text =~ s/\n----\n/\n\n/g; # horizontal line ----
    $text =~ s/^[#:\-\*;]{1,5} *//gm; # bullets, indents, definitions lists
    $text =~ s/\[http.*?\]//g; # [https://example.com]
    $text =~ s/&\w+;/ /g; # &entities;
    $text =~ s/__.\w+?__//g; # __METADATA_;
    $text =~ s/<math>(.|\n)*?<\/math>//g; # LaTeX formulas
    $text =~ s/<source.*?>(.|\n)+<\/source>//g; # source code
    $text =~ s/<\/?.*?\/?>//g; # <other tags>

    return $text
}

1;
