#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Data::DPath qw'dpathr dpath';
use Data::Dumper;

# local $Data::DPath::DEBUG = 1;

BEGIN {
        if ($] < 5.010) {
                plan skip_all => "Perl 5.010 required for the smartmatch overloaded tests. This is ".$];
        }
}

use_ok( 'Data::DPath' );

my $data = {
            'goal' => 15,
           };

# ==================================================

my $res;

# --------------------------------------------------

$res = $data ~~ dpath '/goal';
isnt("".\($data->{goal}), "".\($res->[0]), "ROOT/KEY - references are to copies");
diag "orig:    " . $data->{goal} . " -- " . \($data->{goal});
diag "dpath:   " . $res->[0]     . " -- " . \($res->[0]);

$res = $data ~~ dpathr '/goal';
is("".\($data->{goal}), "".$res->[0], "ROOT/KEY - references are the same");
diag "orig:   \\" . $data->{goal} . " -- " . \($data->{goal});
diag "dpathr: \\" . ${$res->[0]}  . " -- " . $res->[0];

# --------------------------------------------------

$res = $data ~~ dpath '//goal';
isnt("".\($data->{goal}), "".\($res->[0]), "ANYWHERE/KEY - references are to copies");
diag "orig:    " . $data->{goal} . " -- " . \($data->{goal});
diag "dpath:   " . $res->[0]     . " -- " . \($res->[0]);

$res = $data ~~ dpathr '//goal';
is("".\($data->{goal}), "".$res->[0], "ANYWHERE/KEY - references are the same");
diag "orig:   \\" . $data->{goal} . " -- " . \($data->{goal});
diag "dpathr: \\" . ${$res->[0]}  . " -- " . $res->[0];

# --------------------------------------------------

$res = $data ~~ dpath '/*';
isnt("".\($data->{goal}), "".\($res->[0]), "ROOT/ANYSTEP - references are to copies");
diag "orig:    " . $data->{goal} . " -- " . \($data->{goal});
diag "dpath:   " . $res->[0]     . " -- " . \($res->[0]);

$res = $data ~~ dpathr '/*';
is("".\($data->{goal}), "".$res->[0], "ROOT/ANYSTEP - references are the same");
diag "orig:   \\" . $data->{goal} . " -- " . \($data->{goal});
diag "dpathr: \\" . ${$res->[0]}  . " -- " . $res->[0];

# --------------------------------------------------

$res = $data ~~ dpath '//*';
isnt("".\($data->{goal}), "".\($res->[0]), "ANYWHERE/ANYSTEP - references are to copies");
diag "orig:    " . $data->{goal} . " -- " . \($data->{goal});
diag "dpath:   " . $res->[0]     . " -- " . \($res->[0]);

$res = $data ~~ dpathr '//*';
is("".\($data->{goal}), "".$res->[0], "ANYWHERE/ANYSTEP - references are the same");
diag "orig:   \\" . $data->{goal} . " -- " . \($data->{goal});
diag "dpathr: \\" . ${$res->[0]}  . " -- " . $res->[0];

# --------------------------------------------------

my $old = $data->{goal};
my $new = 17;

is($data->{goal}, $old, "ANYWHERE/KEY -- value before change");
$res = $data ~~ dpathr "//goal";
${$res->[0]} = $new;
is($data->{goal}, $new, "ANYWHERE/KEY -- value after change");
$res = $data ~~ dpathr "//goal[ value eq $new]";
is(${$res->[0]}, $new, "ANYWHERE/KEY[FILTER] -- found again with new value");
${$res->[0]} = $old;
is($data->{goal}, $old, "ANYWHERE/KEY[FILTER] -- value changed back to orig");
$res = $data ~~ dpathr "//goal[ value eq $old]";
is(${$res->[0]}, $old, "ANYWHERE/KEY[FILTER] -- found again with orig value");

# --------------------------------------------------

my $old = $data->{goal};
my $new = 17;

# --------------------------------------------------

is($data->{goal}, $old, "modify -- ANYWHERE/KEY -- value before change");
$res = $data ~~ dpathr "//goal";
${$res->[0]} = $new;
is($data->{goal}, $new, "modify -- ANYWHERE/KEY -- value after change");
$res = $data ~~ dpathr "//goal[ value eq $new]";
is(${$res->[0]}, $new, "modify -- ANYWHERE/KEY[FILTER] -- found again with new value");
${$res->[0]} = $old;
is($data->{goal}, $old, "modify -- ANYWHERE/KEY[FILTER] -- value changed back to orig");
$res = $data ~~ dpathr "//goal[ value eq $old]";
is(${$res->[0]}, $old, "modify -- ANYWHERE/KEY[FILTER] -- found again with orig value");

# --------------------------------------------------

is($data->{goal}, $old, "modify -- ANYWHERE/ANYSTEP -- value before change");
$res = $data ~~ dpathr "//*";
${$res->[0]} = $new;
is($data->{goal}, $new, "modify -- ANYWHERE/ANYSTEP -- value after change");
$res = $data ~~ dpathr "//*[ value eq $new]";
is(${$res->[0]}, $new, "modify -- ANYWHERE/ANYSTEP[FILTER] -- found again with new value");
${$res->[0]} = $old;
is($data->{goal}, $old, "modify -- ANYWHERE/ANYSTEP[FILTER] -- value changed back to orig");
$res = $data ~~ dpathr "//*[ value eq $old]";
is(${$res->[0]}, $old, "modify -- ANYWHERE/ANYSTEP[FILTER] -- found again with orig value");

# --------------------------------------------------

is($data->{goal}, $old, "modify -- ANYWHERE/ANYSTEP/PARENT/ANYSTEP -- value before change");
$res = $data ~~ dpathr "//*/../*";
${$res->[0]} = $new;
is($data->{goal}, $new, "modify -- ANYWHERE/ANYSTEP/PARENT/ANYSTEP -- value after change");
$res = $data ~~ dpathr "//*/../*[ value eq $new]";
is(${$res->[0]}, $new, "modify -- ANYWHERE/ANYSTEP/PARENT/ANYSTEP[FILTER] -- found again with new value");
${$res->[0]} = $old;
is($data->{goal}, $old, "modify -- ANYWHERE/ANYSTEP/PARENT/ANYSTEP[FILTER] -- value changed back to orig");
$res = $data ~~ dpathr "//*/../*[ value eq $old]";
is(${$res->[0]}, $old, "modify -- ANYWHERE/ANYSTEP/PARENT/ANYSTEP[FILTER] -- found again with orig value");

# --------------------------------------------------

done_testing();
