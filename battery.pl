#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use Data::Dumper;
use Term::ANSIColor;

sub show_batt {
    my $acpi   = shift;
    my @graph  = qw{ ▁ ▂ ▃ ▅ ▇ };
    my @colors = qw{ green yellow red };

    if ( $acpi =~ /([0-9]{1,3})\%/ ) {
        my $c;
        my $g = $graph[  ( ( $1 * 4) / 100 ) ];

        if    ( $1 > 75 ) { $c = $colors[0]; }
        elsif ( $1 > 25 ) { $c = $colors[1]; }
        else              { $c = $colors[2]; }

        my $string = sprintf ( "[%s] %s", $1 . '%', $g );
        print colored [ $c ], $string . "\n";
    }
}

show_batt( qx{ acpi } );
