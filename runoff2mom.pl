#!/usr/bin/env perl

########################################################################
# Legalese
########################################################################

my $LAST_UPDATE = 'Last update: 5 Jan 2014';

my $VERSION = '0.9';

my $LICENSE = q!
Copyright 2014 Bernd Warken <bernd.warken@web.de>

This file is part of RUNOFF, a free software project.

You can redistribute it and/or modify it under the terms of the GNU
General Public License version 2 or (at your option) any later
version. as published by the Free Software Foundation (FSF).

You can find the text of this license in the file
.B gpl-2.0.txt
in this package, it's also available in the internet at
http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
!;

########################################################################
# this script is just for testing, it does not work so far
########################################################################

$\ = "\n";    # adds newline at each print
$/ = "\n";    # newline separates input
$| = 1;       # flush after each print or write command

use strict;
use warnings;


sub print_chars {
  $\ = '';
  print shift;
  $\ = "\n";
}

my %FLAGS_DEFAULT =
  (
   'CONTROL' => '.',
   'ENDFOOTNOTE' => '!',
   'UPPERCASE' => '^',
   'LOWERCASE' => '\\',
   'UNDERLINE' => '&',
   'SPACE' => '#',
   'QUOTE' => '_',
   'CAPITALIZE' => '<',
   'INDEX' => '>',
   'OVERSTRIKE' => '%',
   'HYPHENATE' => '=',
  );

my %FLAGS_ENABLE =
  (
   'CONTROL' => 1,
   'ENDFOOTNOTE' => 1,
   'UPPERCASE' => 1,
   'LOWERCASE' => 1,
   'UNDERLINE' => 1,
   'SPACE' => 1,
   'QUOTE' => 1,
   'CAPITALIZE' => 0,
   'INDEX' => 0,
   'OVERSTRIKE' => 0,
   'HYPHENATE' => 0,
  );

my %FLAGS_ACTUAL =
  (
   'CONTROL' => '.',
   'ENDFOOTNOTE' => '!',
   'UPPERCASE' => '^',
   'LOWERCASE' => '\\',
   'UNDERLINE' => '&',
   'SPACE' => '#',
   'QUOTE' => '_',
   'CAPITALIZE' => '<',
   'INDEX' => '>',
   'OVERSTRIKE' => '%',
   'HYPHENATE' => '=',
  );

sub flag_enable { # enable flag
  my $arg = shift;
  if ($arg == 'ALL' || $arg == 'null') {
    $FLAGS_ENABLE{ 'UPPERCASE' } = 1;
    $FLAGS_ENABLE{ 'LOWERCASE' } = 1;
    $FLAGS_ENABLE{ 'UNDERLINE' } = 1;
    $FLAGS_ENABLE{ 'SPACE' } = 1;
    $FLAGS_ENABLE{ 'QUOTE' } = 1;
    $FLAGS_ENABLE{ 'CAPITALIZE' } = 1;
    $FLAGS_ENABLE{ 'INDEX' } = 1;
    $FLAGS_ENABLE{ 'OVERSTRIKE' } = 1;
    $FLAGS_ENABLE{ 'HYPHENATE' } = 1;
  } else {
    $FLAGS_ENABLE{ $arg } = 1;
  }
}

sub flag_disable { # disable flag
  my $arg = shift;
  if ($arg == 'ALL' || $arg == 'null') {
    $FLAGS_ENABLE{ 'UPPERCASE' } = 0;
    $FLAGS_ENABLE{ 'LOWERCASE' } = 0;
    $FLAGS_ENABLE{ 'UNDERLINE' } = 0;
    $FLAGS_ENABLE{ 'SPACE' } = 0;
    $FLAGS_ENABLE{ 'QUOTE' } = 0;
    $FLAGS_ENABLE{ 'CAPITALIZE' } = 0;
    $FLAGS_ENABLE{ 'INDEX' } = 0;
    $FLAGS_ENABLE{ 'OVERSTRIKE' } = 0;
    $FLAGS_ENABLE{ 'HYPHENATE' } = 0;
  } else {
    $FLAGS_ENABLE{ $arg } = 0;
  }
}

sub flag_set { # set flag to value
  my $arg = shift;
  my $value = shift;
  $FLAGS_ACTUAL{$arg} = $value;
}

sub flag_get { # get flag name if enabled, otherwise 0
  my $arg = shift;
  return 0 unless ( $FLAGS_ENABLE{ $arg } );
  return $FLAGS_ACTUAL{ $arg };
}


my %abbrev =
  (
   '1966' =>
   {
    'AD' => 'ADJUST',
    'AP' => 'APPEND',
    'BP' => 'BEGION PAGE',
    'BR' => 'BREAK',
    'CD' => 'CENTER',
    'DS' => 'DOUBLE SPACE',
    'FI' => 'FILL',
    'HE' => 'HEADER',
    'HM' => 'HEADING MODE',
    'IN' => 'INDENT',
    'LI' => 'LITERAL',
    'LL' => 'LINE LENGTH',
    'NF' => 'NOFILL',
    'NJ' => 'NOJUST',
    'OP' => 'ODD PAGE',
    'PA' => 'PAGE',
    'PM' => 'PAGING MODE',
    'PL' => 'PAPER LENGTH',
    'SP' => 'SPACE',
    'SS' => 'SINGLE SPACE',
    'UN' => 'UNDENT',
   },

   '1973' =>
   {
   },
  );

# exact number of arguments, -1 is infinite
my %args_exact =
  (
   '1966' =>
   {
    'ADJUST' => 0,
    'APPEND' => 1,
    'BEGIN PAGE' => 0,
    'BREAK' => 0,
    'CENTER' => 0,
    'DOUBLE SPACE' => 0,
    'FILL' => 0,
    'HEADER' => -1,
    'HEADING MODE' => 1,
    'INDENT' => 1,
    'LINE LENGTH' => 1,
    'LITERAL' => 0,
    'NOFILL' => 0,
    'NOJUST' => 0,
    'ODD PAGE' => 0,
    'PAGING MODE' => -1,
    'PAPER LENGTH' => 1,
    'SINGLE SPACE' => 0,
    'UNDENT' => 1,
   },

   '1973' =>
   {
   },

  );

# arguments less or equal a number
my %args_less_or_equal =
  (
   '1966' =>
   {
    'PAGE' => 1,
    'SPACE' => 1,
   },

   '1973' =>
   {
   },
  );

# first command word => all arrays of following command names
my %words =
  (
   'BEGIN' => [
	       [ 'PAGE' ],
	      ],
   'DOUBLE' => [
		[ 'SPACE' ],
	       ],
   'HEADING' => [
		 [ 'MODE' ],
		],
   'LINE' => [
	      [ 'LENGTH' ],
	     ],
   'ODD' => [
	     [ 'PAGE' ],
	    ],
   'PAGING' => [
		[ 'MODE' ],
	       ],
   'PAPER' => [
	       [ 'LENGHT' ],
	      ],
   'SINGLE' => [
		[ 'SPACE' ],
	       ],
  );


my $line;
my @line_words;

foreach ( <> ) {
  chomp;
  $line = $_;

  # test on command line
  my $flag = flag_get( 'CONTROL' );
  if ($flag) {
    my $reg = qr/^
		 [$flag]
		/x;
    if ( $line =~ $reg ) {
      cmd_line( $line );
      next;
    }
  }

  # text line, not a command
  text_line( $line );
}



sub cmd_line {
  my $line = shift;
  print 'command line: ' . $line;
}


sub text_line {
  my $line = shift;

  print 'text line: ' . $line;

  if ( $line =~ /^\s*$/ ) { # line break
    print '.QUOTE';
    print '.QUOTE OFF';
    return;
  }

  if ( $line =~ /^\s+(.*)$/ ) {
    print '.PP';
    print $1;
  }
}


1;
########################################################################
### Emacs settings
# Local Variables:
# mode: CPerl
# End:
