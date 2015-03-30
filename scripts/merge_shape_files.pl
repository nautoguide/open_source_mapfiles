#!/usr/bin/perl

use strict;
use File::Find;
use File::Basename;


sub process_file {

        my ($name, $path, $suffix) = fileparse($File::Find::name, '\..*');
        if($suffix eq '.shp' && $name =~ /[A-Z]{2}_(.*)/) {
                print "GOT $suffix $1 ".$File::Find::name."\n";

                my $filename = $1 . '.shp';

                if(-e $filename) {
                                print "MERGING INTO $filename\n";
                                system 'ogr2ogr -update -append '.$filename .' "'.$File::Find::name . '" ';

                        } else {
                                print "CREATING $filename\n";
                                system  'ogr2ogr '  . $filename .' "'.$File::Find::name . '" ';

                        }
        }


}

find({'wanted' => \&process_file, 'no_chdir' => 1}, @ARGV);