#!/usr/bin/perl -w

#use strict;
use diagnostics;
use CGI;  # available from http://www.perl.com/CPAN/
use Mysql;

# Create an instance of CGI
my $query = new CGI;

# Send an appropriate MIME header
print $query->header("text/html");

# Grab values from the form 
# Prints are for debug only

my $change_course = $query->param("change_course");
my $tf = $query->param("tf");
print "Parameters are(course/X,Y) $change_course, task force id = $tf\n<br>\n";
$pi = 3.14159265358979323846;
if ($change_course =~ /^(.\d*),(.\d*)/)
	{
	print "You passed a X,Y co-ordinate pair, X = $1, Y = $2\n";
	$end_x = $1;
	$end_y = $2;
	$delta_x = ($end_x - $start_x);
	$delta_y = ($end_y - $start_y);
	$heading = atan2($delta_y,$delta_x);
	$heading_deg = $heading * (180 / $pi);
#	print "I can't handle that just yet.\n";
	$pretty_ship_course = 450 - $heading_deg;
        if ($pretty_ship_course > 360)
           {
           $pretty_ship_course -= 360;
           }
	print "This will put this ship on a $pretty_ship_course course.<br>\n";
	$change_course = $pretty_ship_course;
	}
	else
	{
	print "you submitted an absolute course.\n";
	}
# prepare semaphore for instructing impulser about course change.

$ship_course = 450 - $change_course;
        if ($ship_course > 360)
           {
           $ship_course -= 360;
           }

open (CHANGE_COURSE,">tf_course.$$");
print CHANGE_COURSE "$tf:$ship_course\n";
close (CHANGE_COURSE);

open (SEMAPHORE,">tf_course");
print SEMAPHORE "$$\n";
close (SEMAPHORE);

print "Signalling Impulser about course change - waiting for ACK<br>\n";
while (-f "tf_course")
{
}
print "Received ACK - Task Force is now in process of assuming new course<br>\n";
print "Return to <a href=\"http://bigorc.com:4080/game_design/ship_status.html\">Ship Status Page</a><br>\n";
