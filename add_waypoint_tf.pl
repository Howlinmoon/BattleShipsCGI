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
my $new_waypoint = $query->param("waypoint");
my $new_depth = $query->param("depth");
my $tf =  $query->param("tf");
my $new_speed = $query->param("speed");
if ($new_waypoint =~ /^(.\d*),(.\d*)/)
        {
        $waypoint_x = $1;
	$waypoint_y = $2;
        }

my $dbh = Mysql -> connect("localhost","test");

#$waypoints = 0;
#my $command = "";
#        $command = "select waypoints from how_many_waypoints where ship_id = $ship_ID";
#        my $sth=$dbh-> query($command);
#        die "Error with command $command\n" unless (defined $sth);
#        my @arr=();
#        while (@arr = $sth->fetchrow)
#        {
#        ($waypoints) = @arr;
#        }
#print "Ship $ship_ID already has $waypoints waypoints on file<br>\n";
print "A New Waypoint was submitted.<br>\nParameters are Waypoint = $waypoint_x,$waypoint_y depth change = $new_depth Speed = $new_speed Task Force id = $tf\n<br>\n";
# prepare semaphore for instructing impulser about speed change.

open (CHANGE_SPEED,">new_tf_waypoint.$$");
print CHANGE_SPEED "$tf:$waypoint_x:$waypoint_y:$new_depth:$new_speed\n";
close (CHANGE_SPEED);

open (SEMAPHORE,">new_tf_waypoint");
print SEMAPHORE "$$\n";
close (SEMAPHORE);

print "Signalling Impulser about added waypoint - waiting for ACK<br>\n";
print "Longer than 20 seconds? Probally still being ignored - hit stop and try again later<br>\n";
while (-f "new_tf_waypoint")
{
}
print "Received ACK - Task Force has received a new waypoint<br>\n";
print "Return to <a href=\"http://bigorc.com:4080/game_design/ship_status.html\">Ship Status Page</a><br>\n";
