#!/usr/bin/perl
#AUXCOMM MESSAGING FOR PAT WINLINK SERVER - see $ver below

use strict;
use warnings;
#use File::stat;
  
# SET VARIABLES
#######################

#Set up time variables
my ($gsec,$gmin,$ghour,$gmday,$gmon,$gyear,$gwday,$gyday,$gisdst) = gmtime(time);

my ($lsec,$lmin,$lhour,$lmday,$lmon,$lyear,$lwday,$lyday,$lisdst) = localtime(time);

$gyear += 1900;
$gmon += 1;
$lyear += 1900;
$lmon += 1;

my (@pairs, $name, $value, %FORM, $filename, $pair, $htmfile, $htmchars, $err, $first, $bodyr, $htmfilepath, @month, %month, $srnum, $monabbrev, @htmarray);
my $attached = " HTM FILE ALSO ATTACHED";
@month = ('NA','JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');
my $zee = "Z";
#my $zuludy = "$month[$gmon]-$gyear";  #FOR ZULU
my $zuludy = "$month[$lmon]-$lyear";	#FOR LOCAL
#my $bodfile = "/bodfile.txt";
my $p2pmsg = "X-P2ponly: true";
my $rmsg = "*** THIS IS A REPLY ***";

## FOLDER TO USE ACCORDING TO MACHINE IN USE


#BELOW LINE REMED OUT FOR PHONE
#my $folder = "C:/Users/dcayers/.wl2k/mailbox/N4MIO/out/"; #using work pc
##############


#my $folder = "C:/Users/n4mio/.wl2k/mailbox/N4MIO/out/";   #using home pc

#my $folder = "/home/dwayne/.wl2k/mailbox/N4MIO/out/";	  #using Linux

##############################################################################

if ($lmin < "10") {
  $lmin = "0" .$lmin;
 }
 
if ($lhour < "10") {
  $lhour = "0" .$lhour;
 }
 
if ($lmon < "10") {
  $lmon = "0" .$lmon;
 }

if ($lmday < "10") {
  $lmday = "0" .$lmday;
 }


if ($gmin < "10") {
  $gmin = "0" .$gmin;
 }
 
if ($ghour < "10") {
  $ghour = "0" .$ghour;
 }

if ($gmon < "10") {
  $gmon = "0" .$gmon;
 }

if ($gmday < "10") {
  $gmday = "0" .$gmday;
 }

my $ftime = "$lhour:$lmin\n";

my $cgiurl = "index.pl";

my $ver = "1.phone";

# PROCESS FORM DATA
########################
read(STDIN, my $buffer, $ENV{'CONTENT_LENGTH'});

#if no form data go to system start
   if (!$buffer) { 
         &begin;
   }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

# Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
  
}

												#OUTPUT FOR FORM ICS 213
												########################
if ($FORM{'tt'}) {
 #if ($FORM{'msg'}) {
  #if ($FORM{'email'}) {
 
my $incident = uc($FORM{'incident'});
my $to = uc($FORM{'to'});
my $tpos = uc($FORM{'tpos'});
my $email = $FORM{'email'};
my $cc = $FORM{'cc'};
my $from = uc($FORM{'from'});
my $pt = uc($FORM{'title'});
my $subject = uc($FORM{'subject'});
my $date = $FORM{'date'};
my $time = $FORM{'time'};
my $msg = uc($FORM{'msg'});
my $approved = uc($FORM{'approved'});
my $asig = uc($FORM{'asig'});
my $atitle = uc($FORM{'atitle'});
my $reply = $FORM{'reply'};
my $p2p = $FORM{p2p};

#File name generator
my @chars = ("A".."Z", "0".."9");
my $mid;
$mid .= $chars[rand @chars] for 1..12;


#Build body of message file

$filename = "$mid.b2f";  
	
if ($reply) {
    $bodyr = "$rmsg\n\n";
    }
my $body0 = "GENERAL MESSAGE (ICS 213)";
my $body1 = "1. Incident Name (Optional): $incident\n\n";
my $body2 = "2. To (Name): $to\n";
my $body2a = "\tPosition/Title: $tpos\n";
my $body2b = "\tEmail: $email\n\n";
my $body2c = "\tCc: $cc\n\n";
my $body3 = "3. From (Name): $from\n";
my $body3a = "\tPosition/Title: $pt\n";
my $body4 = "4. Subject: $subject\n\n";
my $body5 = "5. Date: $date\n";
my $body6 = "6. Time: $time\n\n";
my $body7 = "7. Message: $msg\n\n";
my $body8 = "8. Approved by: $approved\n";
my $body8a = "\tSignature: $asig\n";
my $body8b = "\tPosition/Title: $atitle\n\n";

chomp($bodyr);
chomp($body0);
chomp($body1);
chomp($body2);
chomp($body2a);
chomp($body2b);
chomp($body2c);
chomp($body3);
chomp($body3a);
chomp($body4);
chomp($body5);
chomp($body6);
chomp($body7);
chomp($body8);
chomp($body8a);
chomp($body8b);


#PRINT ICS 213 FORM TO WEB PAGE
print "Content-type: text/html\n\n";
print "<html><head><title>FORM IC-213 QUEUED FOR DELIVERY</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style></head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";


print "<body style=\"background-color:powderblue;\"><br><br>";
print "<center>";
print "<div id='printMe'>";
print "<br><FONT SIZE = 5><b>$body0</b></FONT>";
print "<br><FONT SIZE = 3 COLOR = RED>$bodyr</FONT><br>";
print "<table style=width:100\%>";
print "<table class=\"center\">";

# 1
print "<tr><th style=text-align:left>\n";
print $body1;
print "</th></tr>\n";

# 2
print "<tr><th style=text-align:left>\n";
print "$body2\&nbsp\;\&nbsp\;$body2a<br><br>\&nbsp\;\&nbsp\;\&nbsp\;$body2b";
	my $body2c_len = length($body2c);
	if ($body2c_len > 7) {
		print "\&nbsp\;\&nbsp\;$body2c";
	}
print "</th></tr>\n";

# 3
print "<tr><th style=text-align:left>\n";
print "$body3\&nbsp\;\&nbsp\;$body3a";
print "</th></tr>\n";

# 4
print "<tr><th style=text-align:left>\n";
print "$body4\&nbsp\;\&nbsp\;$body5\&nbsp\;\&nbsp\;$body6";
print "</th></tr>\n";

# 7
print "<tr><th style=text-align:left>\n";
my @body7_split = split / /, $body7;
print "@body7_split[0..1]\<br>";
print "@body7_split[2..12]<br>";
print "@body7_split[13..22]<br>";
print "@body7_split[23..32]<br>";
print "@body7_split[33..42]<br>";
print "@body7_split[43..52]<br>";
print "@body7_split[53..62]<br>";
print "@body7_split[63..72]<br>";
print "</th></tr>\n";

# 8
print "<tr><th style=text-align:left>\n";
print "$body8\&nbsp\;\&nbsp\;$body8a\&nbsp\;\&nbsp\;$body8b";
print "</th></tr>\n";
print "</table><br>";
print "</div>";

#Add button to print web page

print "<b><input type=button name=print style=background-color:#C42F47 value=\"PRINT MESSAGE\" onClick=printDiv('printMe')>";

print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";

print "<br><br><br><br>";

print "</center></body></html>\n";

#BUILD HTM FILE TO ATTACH TO EMAIL - taken out for script use on phone - mark at 1

#End of code out 1
  
 
exit;
}

												#OUTPUT FOR SIMPLE MESSAGE FORM
												################################
if ($FORM{'sim'}) {
#if ($FORM{'msg'}) {
 # if ($FORM{'email'}) {
 
my $email = $FORM{'email'};
my $cc = $FORM{'cc'};
my $from = uc($FORM{'from'});
my $subject = uc($FORM{'subject'});
my $date = $FORM{'date'};
my $time = $FORM{'time'};
my $msg = uc($FORM{'msg'});
my $reply = $FORM{'reply'};
my $p2p = $FORM{p2p};




#File name generator
my @chars = ("A".."Z", "0".."9");
my $mid;
$mid .= $chars[rand @chars] for 1..12;

#Build body of message file

$filename = "$mid.b2f";  
	
	
#my $bodyr = " ";

 if ($reply) {
     $bodyr = "$rmsg\n\n";
    }
my $body0 = "SIMPLE MESSAGE";
my $body1 = "From (Name): $from\n";
my $body2a = "\tTo: $email\n\n";
my $body2b = "\tCc: $cc\n\n";
my $body3 = "Subject: $subject\n\n";
my $body4 = "Date: $date\n";
my $body5 = "Time: $time\n\n";
my $body6 = "Message:\n $msg\n\n";

#PRINT SIMPLE MESSAGE FORM TO WEB PAGE
print "Content-type: text/html\n\n";
print "<html><head><title>SIMPLE MESSAGE QUEUED FOR DELIVERY</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style></head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";


print "<body style=\"background-color:powderblue;\"><br><br>";
print "<center>";
print "<div id='printMe'>";
print "<br><FONT SIZE = 5><b>$body0</b></FONT>";
print "<br><FONT SIZE = 3 COLOR = RED>$bodyr</FONT><br>";
print "<table style=width:100\%>";
print "<table class=\"center\">";

# From
print "<tr><th style=text-align:left>\n";
print $body1;
print "</th></tr>\n";

# Email address and CC email address
print "<tr><th style=text-align:left>\n";
print "$body2a";
	my $body2b_len = length($body2b);
	if ($body2b_len > 7) {
		print "\&nbsp\;\&nbsp\;$body2b";
	}
print "</th></tr>\n";


# Subject, date and time
print "<tr><th style=text-align:left>\n";
print "$body3\&nbsp\;\&nbsp\;$body4\&nbsp\;\&nbsp\;$body5";
print "</th></tr>\n";

# Message
print "<tr><th style=text-align:left>\n";
my @body6_split = split / /, $body6;
print "@body6_split[0]\<br>";
print "@body6_split[1..12]<br>";
print "@body6_split[13..22]<br>";
print "@body6_split[23..32]<br>";
print "@body6_split[33..42]<br>";
print "@body6_split[43..52]<br>";
print "@body6_split[53..62]<br>";
print "@body6_split[63..72]<br>";
print "</th></tr>\n";

print "</table><br>";
print "</div>";

#Add button to print web page

print "<b><input type=button name=print style=background-color:#C42F47 value=\"PRINT MESSAGE\" onClick=printDiv('printMe')>";

print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";

print "<br><br><br><br>";

print "</center></body></html>\n";

#TAKEN OUT OF ORIGINAL - mark at 2

#End of code out 2
  
 
exit;
}

                                      #OUTPUT FOR FORM SPOTREP
                                     ###########################
if ($FORM{'srep'}) {
 #if ($FORM{'sprfrm'}) {
  #if ($FORM{'sprto'}) {


# TABLE 1
my $sprtmedte = $FORM{'sprtmedte'};
my $sprfrm = uc($FORM{'sprfrm'});
my $sprto = $FORM{'sprto'};
my $sprcc = $FORM{'sprcc'};

# TABLE 2
# 1
my $sprcst = uc($FORM{'sprcst'});
# 2
my $choose2 = $FORM{'choose2'};
my $comm2 = uc($FORM{'Comm2'});
# 3
my $choose3 = $FORM{'choose3'};
my $comm3 = uc($FORM{'Comm3'});
# 4
my $comm4 = uc($FORM{'Comm4'});
# 5
my $comm5 = uc($FORM{'Comm5'});
# 6
my $comm6 = uc($FORM{'Comm6'});
# 7
my $comm7 = uc($FORM{'Comm7'});
# 8
my $choose8 = $FORM{'choose8'};
my $comm8 = uc($FORM{'Comm8'});

# TABLE 3
my $comm9 = uc($FORM{'Comm9'});

# TABLE 4
my $sprpoc = uc($FORM{'sprpoc'});

my $p2p = $FORM{p2p};

#File name generator
my @chars = ("A".."Z", "0".."9");
my $mid;
$mid .= $chars[rand @chars] for 1..12;

#Build body of message file

$filename = "$mid.b2f";  
	
# TABLE 1	
my $body0 = "SPOTREP";
my $body1 = "\tR: \&nbsp\;$sprtmedte";
my $body1a = "\tFROM: \&nbsp\;$sprfrm\n";
my $body1b = "\tTO: \&nbsp\;$sprto\n";
my $body1c = "\tINFO (CC): \&nbsp\;$sprcc\n\n";

# TABLE 2
# 1
my $body2 = "\t1. City/State/Territory: \&nbsp\;$sprcst\n\n";
# 2
my $body2a = "\t2. LandLine works? \&nbsp\;$choose2\n";
my $body2b = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm2\n";
# 3
my $body2c = "\t3. Cell Phone Works? \&nbsp\;$choose3\n";
my $body2d = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm3\n";
# 4
my $body2e = "\t4. AM/FM Broadcast Stations Status\n";
my $body2f = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm4\n";
# 5
my $body2g = "\t5. TV Stations Status\n";
my $body2h = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm5\n";
# 6
my $body2i = "\t6. Public Water Works Status\n";
my $body2j = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm6\n";
# 7
my $body2k = "\t7. Commercial Power Status\n";
my $body2l = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm7\n";
# 8
my $body2m = "\t8. Internet Working? \&nbsp\;$choose8\n";
my $body2n = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm8\n";

# TABLE 3
my $body3 = "\tAdditional Comments\n";
my $body3a = "\t\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$comm9\n";

# TABLE 4
my $body4 = "\tPOC\n";
my $body4a = "\t$sprpoc\n";

#PRINT SPOTREP TO WEB PAGE
print "Content-type: text/html\n\n";
print "<html><head><title>FORM SPOTREP QUEUED FOR DELIVERY</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style></head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";


print "<body style=\"background-color:dbc3c1;\"><br><br>";
print "<center>";
print "<div id='printMe'>";
print "<br><FONT SIZE = 6><b>$body0</b></FONT><br>";
print "<table style=width:100\%>";
print "<table class=\"center\">";

# TABLE 1
print "<tr><th style=text-align:left>\n";
print "<font size = 4>";
print "$body1\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "$body1a<br><br>";
print "$body1b<br><br>";
print "$body1c<br>";
print "</th></tr>\n";

# TABLE 2
# 1
print "<tr><th style=text-align:left>\n";
print "$body2<br><br>\n";
#2
print "$body2a\&nbsp\;\&nbsp\;\n";
print "<br><br>$body2b<br><br>\n";
#3
print "$body2c\&nbsp\;\&nbsp\;\n";
print "<br><br>$body2d<br><br>\n";
#4
print "$body2e<br><br>\n";
print "$body2f<br><br>\n";
#5
print "$body2g<br><br>\n";
print "$body2h<br><br>\n";
#6
print "$body2i<br><br>\n";
print "$body2j<br><br>\n";
#7
print "$body2k<br><br>\n";
print "$body2l<br><br>\n";
#8
print "$body2m\&nbsp\;\&nbsp\;\n";
print "<br><br>$body2n\&nbsp\;\&nbsp\;\n";
print "</th></tr>\n";

# TABLE 3
print "<tr><th style=text-align:left>\n";
print "$body3\n";
print "<br><br>$body3a<br>\n";
print "</th></tr>\n";

# TABLE 4
print "<tr><th style=text-align:left>\n";
print "$body4\&nbsp\;\&nbsp\;\n";
print "$body4a\n";
print "</th></tr>\n";
print "</table>";

print "</div></font><br>";

#Add button to print web page

print "<b><input type=button name=print style=background-color:#C42F47 value=\"PRINT MESSAGE\" onClick=printDiv('printMe')>";

print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";

print "<br><br><br><br>";

print "</center></body></html>\n";

#TAKEN OUT OF ORIGINAL - mark at 3

#End of code out 3
  
 
exit;
}

												#OUTPUT FOR FORM RADIOGRAM
												##########################
if ($FORM{'rgram'}) {
 #if ($FORM{'rgmsg'}) {
  #if ($FORM{'email'}) {
 
my $rnum = $FORM{'rnum'};
my $rpres = $FORM{'rpres'};
my $rhx = $FORM{'rhx'};
	if (!$rhx) {
		$rhx = "NONE";
	}
my $rsoo = uc($FORM{'rsoo'});
my $rck = $FORM{'rck'};
my $rpoo = uc($FORM{'rpoo'});
my $rtim = $FORM{'rtim'};
my $rdt = $FORM{'rdt'};
my $rto = uc($FORM{'rto'});
my $rto1 = uc($FORM{'rto1'});
my $rto2 = uc($FORM{'rto2'});
my $rtel = $FORM{'rtel'};
my $email = $FORM{'email'};
my $cc = $FORM{'cc'};
my $ras = uc($FORM{'ras'});
my $rph = $FORM{'rph'};
my $rnme = uc($FORM{'rnme'});
my $rstr = uc($FORM{'rstr'});
my $rcsz = uc($FORM{'rcsz'});
my $rgmsg = uc($FORM{'rgmsg'});
my $rrfrm = uc($FORM{'rrfrm'});
my $rrdte = $FORM{'rrdte'};
my $rrtme = $FORM{'rrtme'};
my $rsto = uc($FORM{'rsto'});
my $rsdte = $FORM{'rsdte'};
my $rstme = $FORM{'rstme'};
my $reply = $FORM{'reply'};
my $p2p = $FORM{'p2p'};
 
$rck += $rgmsg =~ s/((^|\s)\S)/$1/g;

#File name generator
my @chars = ("A".."Z", "0".."9");
my $mid;
$mid .= $chars[rand @chars] for 1..12;

#Build body of message file

$filename = "$mid.b2f";  

 if ($reply) {
     $bodyr = "$rmsg\n\n";
    }

my $body0 = "RADIOGRAM";
# Table 1
my $body1 = "Number: $rnum\n";
my $body1a = "Precedence: $rpres\n";
my $body1b = "HX: $rhx\n";
my $body1c = "Station of Origin: $rsoo\n";
my $body1d = "Check: $rck\n";
my $body1e = "Place of Origin: $rpoo\n";
my $body1f = "Time Filed: $rtim\n";
my $body1g = "Date: $rdt\n\n";
# Table 2 section 1
my $body2 = "To: $rto\n";
my $body2a = "To: $rto1\n";
my $body2b = "To: $rto2\n";
my $body2c = "Telephone Number: $rtel\n";
my $body2d = "Email Address: $email\n";
my $body2e = "Cc: $cc\n\n";
# Table 2 section 2
my $body2k = "This radio message was received at";
my $body2f = "Amateur Staion: $ras\n";
my $body2g = "Phone: $rph\n";
my $body2h = "Name: $rnme\n";
my $body2i = "Street: $rstr\n";
my $body2j = "City State Zip: $rcsz\n\n";
# Table 3
my $body3 = "Message: $rgmsg\n\n";
# Table 4 Section 1
my $body4 = "REC'D\n";
my $body4a = "From: $rrfrm\n";
my $body4b = "Date: $rrdte\n";
my $body4c = "Time: $rrtme\n\n";
# Table 4 Section 2
my $body4d = "SENT\n";
my $body4e = "To: $rsto\n";
my $body4f = "Date: $rsdte\n";
my $body4g = "Time: $rstme\n\n\n";

# PRINT RADIOGRAM FORM TO WEB PAGE
print "Content-type: text/html\n\n";
print "<html><head><title>RADIOGRAM</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style>";
print " <style type=text/css>
            dummydeclaration { padding-left: 1em; } /* Firefox ignores first declaration for some reason */
			tab0 { padding-left: 1em; }
            tab1 { padding-left: 2em; }
            tab2 { padding-left: 3em; }
            tab3 { padding-left: 4em; }
            tab4 { padding-left: 5em; }
            tab5 { padding-left: 6em; }
            tab6 { padding-left: 7em; }
            tab7 { padding-left: 8em; }
            tab8 { padding-left: 9em; }
            tab9 { padding-left: 36em; }
            tab10 { padding-left: 40em; }
            tab11 { padding-left: 44em; }
            tab12 { padding-left: 48em; }
            tab13 { padding-left: 52em; }
            tab14 { padding-left: 56em; }
            tab15 { padding-left: 60em; }
            tab16 { padding-left: 64em; }

        </style>";
print "</head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";

print "<body style=\"background-color:6db070;\"><br><br>";
print "<center>";
print "<div id='printMe'>";
print "<br><FONT SIZE = 7><b>$body0</b></FONT>";
print "<br><FONT SIZE = 3 COLOR = RED>$bodyr</FONT><br>";

#Table setup
print "<table style=width:100\%>";
print "<table class=\"center\">";

#Fields of Radiogram form
# TABLE 1
# Header Line
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 2 color = Black><i>Number";
print "<tab1>Precedence</tab1>";
print "<tab2>HX</tab2>";
print "<tab1>Station of Origin</tab1>";
print "<tab0>Check</tab0>";
print "<tab1>Place of Origin</tab1>";
print "<tab5>Time Filed</tab5>";
print "<tab0>Date</tab0></font></i>";

# Table 1
print "<br><br>";
print "<FONT SIZE = 2 color = Black>$rnum\n";
print "<tab3>$rpres</tab3>";
print "<tab0>$rhx</tab0>";
print "<tab1>$rsoo</tab1>";
print "<tab4>$rck</tab4>";
print "<tab1>$rpoo</tab1>";
print "<tab3>$rtim</tab3>";
print "<tab0>$rdt</tab0>";
print "</tr></th></table>\n";

# TABLE 2
print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<i><FONT SIZE = 3 color = Black>TO:</font></i><br>\n";
print "<FONT SIZE = 2 color = Black><tab1>$rto</tab1><br>";
print "<tab1>$rto1</tab1><br>";
print "<tab1>$rto2</tab1><br>";
#print "<br><br><i>Telephone Number:</i><br>\n";
print "<tab1>$rtel</tab1><br>\n";
#print "<i>Email Address:</i><br>\n";
print "<tab1>$email</tab1><br>\n";
print "<i>Cc:</i><br>\n";
print "<tab1>$cc</tab1><br></font>\n";
print "</th>\n";
print "<th style=text-align:left>\n";
print "<center><font size = 1 color = Black><i>THIS RADIO MESSAGE<br>WAS RECEIVED AT<br><br></i></font>\n";
print "<font size = 2 color = Black>AMATEUR STATION:</center><br>\n";
print "<tab1>$ras</tab1>\n";
print "<tab1>$rph</tab1><br>\n";
print "<tab1>$rnme</tab1><br>\n";
print "<tab1>$rstr</tab1><br>\n";
print "<tab1>$rcsz</tab1><br>\n";
print "</font></th></tr></table>\n";


# TABLE 3
print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black><i>MESSAGE:</i></font><br>\n";
print "<FONT SIZE = 2 color = Black>";
my @rmsg_split = split / /, $rgmsg;
print "<tab5>@rmsg_split[0..7]</tab5><br>";
print "<tab5>@rmsg_split[8..16]</tab5><br>";
print "<tab5>@rmsg_split[17..24]</tab5><br>";
print "</font>";
print "</th></tr></table>\n";

# TABLE 4

print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 2 color = Black><i><Tab5>From</Tab5><Tab2>Date</Tab2><Tab4>Time</Tab4></i></font><br>\n";
print "<FONT SIZE = 3 color = Black>REC'D</font>\n";
print "<font size = 2 color = black><Tab1>$rrfrm</Tab1>\n";
print "<Tab1>$rrdte</Tab1>\n";
print "<Tab2>$rrtme</Tab2>\n";
print "</font></th>\n";

print "<th style=text-align:left>\n";
print "<FONT SIZE = 2 color = Black><Tab5><i>To</Tab5><Tab3>Date</Tab3><Tab4>Time</Tab4></i></font><br>\n";
print "<font size = 3 color = Black>SENT</font>\n";
print "<font size = 2 color = black><tab1>$rsto</Tab1>\n";
print "<tab1>$rsdte</Tab1>\n";
print "<tab2>$rstme</Tab2>\n";
print "</th></tr></table>\n";

print "</div></font><br>";

#Add button to print web page

print "<b><input type=button name=print style=background-color:#C42F47 value=\"PRINT MESSAGE\" onClick=printDiv('printMe')>";

print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";

print "<br><br><br><br>";

print "</center></body></html>\n";

#TAKEN OUT OF ORIGINAL - mark at 4

#End of code out 4

 
exit;
}

#MAIN PAGE MENU (FORMS)
#######################
if ($FORM{'213'}) {
&twothirteen;
}

if ($FORM{'rg'}) {
&radiogram;
}

if ($FORM{'simple'}) {
&simple;
}

if ($FORM{'text'}) {
&text;
}

if ($FORM{'sp'}) {
&spotrep;
}

#SUBROUTINES
#######################
#Main Menu
sub begin {
print "Content-type: text/html\n\n";
print "<html><head><title>AUXCOMM MESSAGING SERVER $ver</title></head>\n";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<body style=\"background-color:db3033;\"><center><FONT SIZE = 6><b>AUXCOMM MESSAGING SERVER</b></FONT><FONT SIZE = 2 color = purple>\&nbsp\;\&nbsp\;<b>$ver</b></font><br>\n";
print "<br><FONT SIZE = 5 COLOR = 1f1a1a><I>CREATE YOUR MESSAGE</I></FONT><BR><BR><BR>";
print "<FORM ACTION=$cgiurl METHOD=POST>";
print "<INPUT TYPE=submit  style=\"font-size:20px; background-color:FFCC33; color:Black; border: 3pt ridge grey\" NAME=213 VALUE=\"GENERAL MESSAGE (ICS 213)\"><br><br><br>";
print "<INPUT TYPE=submit style=\"font-size:20px; background-color:53b1e0; color:Black; border: 3pt ridge grey\" NAME=simple VALUE=\"SIMPLE MESSAGE\"><br><br><br>";
print "<INPUT TYPE=submit NAME=rg VALUE=\"RADIOGRAM\" style=\"font-size:20px; background-color:395935; color:d6bc47; border: 3pt ridge grey\"><br><br><br>";
print "<INPUT TYPE=submit NAME=sp VALUE=\"SPOTREP\" style=\"font-size:20px; background-color:dbc3c1; color:Black; border: 3pt ridge grey\">";
print "</form>\n";

print "</center>";
print "</body></html>\n";
exit;
}

#FORM IC-213
sub twothirteen {
print "Content-type: text/html\n\n";
print "<html><head><title>GENERAL MESSAGE (ICS 213)</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 20px; height: 20px; } </style>";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style>";
print "</head>\n";
print "<body style=\"background-color:FFCC33;\"><center><FONT SIZE = 7><b><br>GENERAL MESSAGE (ICS 213)</b></FONT><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

print "<input id=tt name=tt type=hidden value=two13>\n";

# P2P checkbox
print "<FONT SIZE = 3 color = Black><b>P2P</font>\&nbsp\;</b>\n";
print "<input id=p2p name=p2p type=checkbox value=1 class=largerCheckbox><br><br>\n";

# Reply checkbox
print "<FONT SIZE = 3 color = Black><b>CHECK HERE IF REPLY</font>\&nbsp\;</b>\n";
print "<input id=reply name=reply type=checkbox value=1 class=largerCheckbox><br><br>\n";

#Fields of 213 form
# 1

print "<table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>1. Incident Name (Optional):</font>\&nbsp\;\&nbsp\;";
print "<input id=incident name=incident size=60 type=text><br>\n";
print "</th></tr>\n";

# 2
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>2. To (Name):\&nbsp\;\&nbsp\;</font>\n";
print "<input id=to name=to size=30 type=text>\&nbsp\;\&nbsp\;\n";

print "<FONT SIZE = 3 color = Black>Position/Title:\&nbsp\;\&nbsp\;</font>\n";
print "<input id=tpos name=tpos size=30 type=text><br><br>\n";

print "<FONT SIZE = 3 color = Black>Email Address\&nbsp\;<b>(Required):</b></font>\n";
print "<input id=email name=email size=30 type=text>\&nbsp\;\&nbsp\;\n";

print "<FONT SIZE = 3 color = Black>Cc:\&nbsp\;\&nbsp\;</font>\n";
print "<input id=cc name=cc size=30 type=text><br>\n";
#print "<FONT SIZE = 2 color = red>[Can be Winlink user alias]</font><br>\n";
print "<br><center><i><font size=2 color=#0c2b5c>Calls or E-mails entered into the Email or CC fields above, can be multiples separated by a semicolon</font></i></center>";
print "</th></tr>\n";

# 3
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>3. From (Name):</font>\&nbsp\;\&nbsp\;\n";
print "<input id=from name=from size=30 type=text>\&nbsp\;\&nbsp\;\n";

print "<FONT SIZE = 3 color = Black>Position/Title:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=title name=title size=30 type=text>\&nbsp\;\&nbsp\;\n";

print "</th></tr>\n";

# 4
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>4. Subject:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=subject name=subject size=30 type=text>\&nbsp\;\&nbsp\;\n";

# 5
print "<FONT SIZE = 3 color = Black>5. Date:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=date name=date size=14 type=text value=$lmon\/$lmday\/$lyear>\&nbsp\;\&nbsp\;\n";

# 6
print "<FONT SIZE = 3 color = Black>6. Time:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=time name=time size=7 type=text value=$ftime><br>\n";
print "</th></tr>\n";

# 7
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>7. Message: <b>(Required)</b></font><br>\n";
print "<textarea name=msg cols=100 rows=10></textarea><br>";
print "</th></tr>\n";

# 8
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>8. Approved by (Name):</font>\&nbsp\;\&nbsp\;\n";
print "<input id=approved name=approved size=15 type=text>\&nbsp\;\&nbsp\;\n";

print "<FONT SIZE = 2 color = Black>Position/Title:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=atitle name=atitle size=15 type=text>\&nbsp\;\&nbsp\;\n";

print "<FONT SIZE = 2 color = Black>Signature:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=asig name=asig size=15 type=text><br>\n";
print "</th></tr>\n";
print "</table>";

print "<br><input type=submit>\&nbsp\;\&nbsp\;\n";
print "<input type=reset>\n";
print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";
print "</form></center>";

print "<br><br><br><br></body></html>\n";

exit;

}

#FORM SIMPLE MESSAGE
sub simple {
print "Content-type: text/html\n\n";
print "<html><head><title>SIMPLE MESSAGE</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 20px; height: 20px; } </style>";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style>";
print "</head>\n";
print "<body style=\"background-color:53b1e0;\"><center><FONT SIZE = 7><b><br>SIMPLE MESSAGE</b></FONT><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

print "<input id=sim name=sim type=hidden value=simple>\n";

# P2P checkbox
print "<FONT SIZE = 3 color = Black><b>P2P</font>\&nbsp\;</b>\n";
print "<input id=p2p name=p2p type=checkbox value=1 class=largerCheckbox><br><br>\n";

# Reply checkbox
print "<FONT SIZE = 3 color = Black><b>CHECK HERE IF REPLY</font>\&nbsp\;</b>\n";
print "<input id=reply name=reply type=checkbox value=1 class=largerCheckbox><br><br>\n";

#Fields of Simple Message form
# table setup
print "<table style=width:100\%>";
print "<table class=\"center\">";

# From
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>From (Name):</font>\&nbsp\;\&nbsp\;\n";
print "<input id=from name=from size=30 type=text>\&nbsp\;\&nbsp\;\n";
print "</th></tr>\n";

# To
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>To Email Address\&nbsp\;<b>(Required):</b></font>\n";
print "<input id=email name=email size=30 type=text>\&nbsp\;\&nbsp\;\n";

# CC
print "<FONT SIZE = 3 color = Black>CC:\&nbsp\;\&nbsp\;</font>\n";
print "<input id=cc name=cc size=30 type=text><br>\n";
print "<br><center><i><font size=2 color=#0c2b5c>Calls or E-mails entered into the TO or INFO fields above, can be multiples separated by a semicolon</font></i></center>";
#print "<FONT SIZE = 2 color = purple>[Can be Winlink user alias]</font><br>\n";
print "</th></tr>\n";

# Subject
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>Subject:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=subject name=subject size=30 type=text>\&nbsp\;\&nbsp\;\n";

# Date
print "<FONT SIZE = 3 color = Black>Date:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=date name=date size=14 type=text value=$lmon\/$lmday\/$lyear>\&nbsp\;\&nbsp\;\n";

# Time
print "<FONT SIZE = 3 color = Black>Time:</font>\&nbsp\;\&nbsp\;\n";
print "<input id=time name=time size=7 type=text value=$ftime><br>\n";
print "</th></tr>\n";

# Message
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>Message: <b>(Required)</b></font><br>\n";
print "<textarea name=msg cols=100 rows=10></textarea><br>";
print "</th></tr>\n";


print "</table>";

print "<br><input type=submit>\&nbsp\;\&nbsp\;\n";
print "<input type=reset>\n";
print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";
print "</form></center>";

print "<br><br><br><br></body></html>\n";

exit;

}

#FORM RADIOGRAM
sub radiogram {
print "Content-type: text/html\n\n";
print "<html><head><title>RADIOGRAM FOR PAT WINLINK</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 20px; height: 20px; } </style>";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style>";
print " <style type=text/css>
            dummydeclaration { padding-left: 1em; } /* Firefox ignores first declaration for some reason */
			tab0 { padding-left: 1em; }
            tab1 { padding-left: 2em; }
            tab2 { padding-left: 3em; }
            tab3 { padding-left: 4em; }
            tab4 { padding-left: 5em; }
            tab5 { padding-left: 6em; }
            tab6 { padding-left: 7em; }
            tab7 { padding-left: 8em; }
            tab8 { padding-left: 9em; }
            tab9 { padding-left: 36em; }
            tab10 { padding-left: 40em; }
            tab11 { padding-left: 44em; }
            tab12 { padding-left: 48em; }
            tab13 { padding-left: 52em; }
            tab14 { padding-left: 56em; }
            tab15 { padding-left: 60em; }
            tab16 { padding-left: 64em; }

        </style>";
print "</head>\n";
print "<body style=\"background-color:6db070;\"><center><FONT SIZE = 7><b><br>RADIOGRAM</b></FONT><br><br>\n";

print "<form method=POST action=$cgiurl>\n";

print "<input id=rgram name=rgram type=hidden value=radiogram>\n";
# P2P checkbox
print "<FONT SIZE = 3 color = Black><b>P2P</font>\&nbsp\;</b>\n";
print "<input id=p2p name=p2p type=checkbox value=1 class=largerCheckbox><tab3>\n";
# Reply checkbox
print "</tab3><FONT SIZE = 3 color = Black><b>CHECK HERE IF REPLY</font>\&nbsp\;</b>\n";
print "<input id=reply name=reply type=checkbox value=1 class=largerCheckbox><br><br>\n";

#Table setup
print "<table style=width:100\%>";
print "<table class=\"center\">";

#Fields of Radiogram form
# TABLE 1
# Header Line
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>Number</font>";
print "<tab3><FONT SIZE = 3 color = Black>Precedence</tab3></font>";
print "<tab1><FONT SIZE = 3 color = Black>HX</tab1></font>";
print "<tab1><FONT SIZE = 3 color = Black>Station of Origin</tab1></font>";
print "<tab0><FONT SIZE = 3 color = Black>Check</tab0></font>";
print "<tab1><FONT SIZE = 3 color = Black>Place of Origin</tab1></font>";
print "<tab0><FONT SIZE = 3 color = Black>Time Filed</tab0></font>";
print "<tab0><FONT SIZE = 3 color = Black>Date</tab0></font>";

# Input fields
print "<br>";
print "<input id=rnum name=rnum size=4 type=text>\n";
print  "<input list=rpres name=rpres size=16>\n";
print  "<datalist id=rpres>\n";
print  "<option value=EMERGENCY>\n";
print  "<option value=PRIORITY (P)>\n";
print  "<option value=WELFARE (W)>\n";
print  "<option value=ROUTINE (R)>\n";
print  "<option value=TEST EMERGENCY>\n";
print  "</datalist>\n";
print  "<input list=rhx name=rhx size=3>\n";
print  "<datalist id=rhx>\n";
print  "<option value=NONE>\n";
print  "<option value=HXA>\n";
print  "<option value=HXB>\n";
print  "<option value=HXC>\n";
print  "<option value=HXD>\n";
print  "<option value=HXE>\n";
print  "<option value=HXG>\n";
print  "</datalist>\n";
print "<input id=rsoo name=rsoo size=13 type=text>\n";
print "<input id=rck name=rck size=3 type=text disabled=disabled>\n";
print "<input id=rpoo name=rpoo size=13 type=text>\n";
print "<input id=rtim name=rtim size=6 type=text value=$ftime>\n";
print "<input id=rdt name=rdt size=6 type=text value=$lmon\/$lmday\/$lyear>\n";
print "</tr></th></table>\n";

# TABLE 2
print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>TO</font>\n";
print "<center><input id=rto name=rto size=48 type=text><br><br>\n";
print "<input id=rto1 name=rto1 size=48 type=text><br><br>\n";
print "<input id=rto2 name=rto2 size=48 type=text></center>\n";
#print "<br><textarea name=rto cols=50 rows=6></textarea><br>";
print "<br><FONT SIZE = 3 color = Black>Telephone Number</font>\n";
print "<input id=rtel name=rtel size=19 type=text><br>\n";
print "<br><FONT SIZE = 3 color = Black>Email Address</b></font>\n";
print "<input id=email name=email size=23 type=text><br><br>\n";
#print "<FONT SIZE = 2 color = #102547>*Email and Cc can be Winlink user alias</font><br>\n";
print "<center><i><font size=2 color=102547>Calls or E-mails entered into the Email Address or Cc fields<br> can be multiples separated by a semicolon</font></i></center>";
print "<br><FONT SIZE = 3 color = Black>Cc:\&nbsp\;\&nbsp\;</font>\n";
print "<input id=cc name=cc size=33 type=text><br>\n";
print "</th>\n";
print "<th style=text-align:left>\n";
print "<center><font size = 2 color = Black>THIS RADIO MESSAGE WAS RECEIVED AT</font></center><br>\n";
print "<font size = 2 color = Black>AMATEUR STATION</font>\n";
print "<input id=ras name=ras size=25 type=text><br><br>\n";
print "<font size = 2 color = Black>PHONE</font>\n";
print "<input id=rph name=rph size=13 type=text><br><br>\n";
print "<font size = 2 color = Black>NAME</font>\n";
print "<input id=rnme name=rnme size=35 type=text><br><br>\n";
print "<font size = 2 color = Black>STREET</font>\n";
print "<input id=rstr name=rstr size=30 type=text><br><br>\n";
print "<font size = 2 color = Black>CITY, STATE ZIP</font>\n";
print "<input id=rcsz name=rcsz size=33 type=text><br>\n";
print "</th></tr></table>\n";


# TABLE 3
print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>MESSAGE</font>\n";
print "<FONT SIZE = 2 color = #102547>*25 words or less, no punctuation, use \"X\" in between words to signify punctuation (counts as a word)</font>\n";
print "<br><textarea name=rgmsg cols=107 rows=5></textarea><br>";
print "</th></tr></table>\n";

# TABLE 4

print "<br><table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<Tab6><FONT SIZE = 2 color = Black>From</Tab6><Tab6>Date</Tab6><Tab4>Time</Tab4></font><br>\n";
print "<FONT SIZE = 4 color = Black>REC'D</font><Tab0>\n";
print "</Tab0><input id=rrfrm name=rrfrm size=12 type=text><Tab0>\n";
print "<input id=rrdte name=rrdte size=5 type=text><Tab0>\n";
print "<input id=rrtme name=rrtme size=5 type=text></Tab0>\n";
print "</th>\n";

print "<th style=text-align:left>\n";
print "<Tab6><FONT SIZE = 2 color = Black>To</Tab6><Tab6>Date</Tab6><Tab4>Time</Tab4></font><br>\n";
print "<font size = 4 color = Black>SENT</font><Tab0>\n";
print "</Tab0><input id=rsto name=rsto size=11 type=text><Tab0>\n";
print "<input id=rsdte name=rsdte size=5 type=text><Tab0>\n";
print "<input id=rstme name=rstme size=5 type=text></Tab0>\n";
print "</th></tr></table>\n";

print "<br><input type=submit>\&nbsp\;\&nbsp\;\n";
print "<input type=reset>\n";
print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";
print "</form></center>";

print "<br><br><br><br></body></html>\n";

exit;

}
# SPOTREP FORM BUILDER
sub spotrep {
print "Content-type: text/html\n\n";
print "<html><head><title>SPOTREP</title>";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
print "<!-- Style to set the size of checkbox --> <style> input.largerCheckbox { width: 20px; height: 20px; } </style>";
print "<style>table, th, td {border: 2px solid black;border-collapse: collapse;padding: 10px;}</style>";
print "</head>\n";
print "<body style=\"background-color:dbc3c1;\"><center><FONT SIZE = 7><b><br>SPOTREP</b></FONT><br><br>\n";
print "<form method=POST action=$cgiurl>\n";
print "<input id=srep name=srep type=hidden value=spotrep>\n";

# P2P checkbox
print "<FONT SIZE = 3 color = Black><b>P2P</font>\&nbsp\;</b>\n";
print "<input id=p2p name=p2p type=checkbox value=1 class=largerCheckbox><br><br>\n";

#Fields of SPOTREP form
# TABLE 1

print "<table style=width:100\%>";
print "<table class=\"center\">";
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 4 color = Black>R:\&nbsp\;\&nbsp\;\&nbsp\;</font>";
#FOR ZULU
#print "<input id=sprtmedte name=sprtmedte size=20 type=text value=$gmday$ghour$gmin$zee\-$zuludy>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\n";
#FOR LOCAL
print "<input id=sprtmedte name=sprtmedte size=20 type=text value='$lmon-$lmday-$lyear $lhour\:$lmin\:$lsec'>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "<FONT SIZE = 4 color = Black>FROM:</font>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input id=sprfrm name=sprfrm size=20 type=text><br><br>\n";
print "<FONT SIZE = 4 color = Black>TO:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</font>\n";
print "<textarea id=sprto name=sprto cols=75 rows=1></textarea><br>";
print "<FONT SIZE = 4 color = Black>INFO (CC):\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</font>\n";
print "<textarea id=sprcc name=sprcc cols=70 rows=1></textarea><br>";
print "<center><i><font size=2 color=blue>Calls or E-mails entered into the TO or INFO fields above, can be multiples separated by a semicolon</font></i></center>";
print "</th></tr>\n";

# TABLE 2
# 1
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>1. City/State/Territory:\&nbsp\;\&nbsp\;\n";
print "<input id=sprcst name=sprcst size=60 type=text><br><br>\n";
#2
print "2. LandLine works?\&nbsp\;\&nbsp\;\n";
print "<input type=radio id=spryes2 name=choose2 value=YES><label for=spryes2>YES</label><input type=radio id=sprno2 name=choose2 value=NO>
	   <label for=sprno2>NO</label><input type=radio id=sprna2 name=choose2 value=NA><label for=sprna2>Unknown - N/A</label>\&nbsp\;\&nbsp\;\n";
print "<br><textarea placeholder=Comments name=Comm2 cols=90 rows=1 id=Comm2 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#3
print "3. Cell Phone Works?\&nbsp\;\&nbsp\;\n";
print "<input type=radio id=spryes3 name=choose3 value=YES><label for=spryes3>YES</label><input type=radio id=sprno3 name=choose3 value=NO>
	   <label for=sprno3>NO</label><input type=radio id=sprna3 name=choose3 value=NA><label for=sprna3>Unknown - N/A</label>\&nbsp\;\&nbsp\;\n";
print "<br><textarea placeholder=Comments name=Comm3 cols=90 rows=1 id=Comm3 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#4
print "4. AM/FM Broadcast Stations Status<br>\n";
print "<textarea placeholder=Comments name=Comm4 cols=90 rows=1 id=Comm4 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#5
print "5. TV Stations Status<br>\n";
print "<textarea placeholder=Comments name=Comm5 cols=90 rows=1 id=Comm5 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#6
print "6. Public Water Works Status<br>\n";
print "<textarea placeholder=Comments name=Comm6 cols=90 rows=1 id=Comm6 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#7
print "7. Commercial Power Status<br>\n";
print "<textarea placeholder=Comments name=Comm7 cols=90 rows=1 id=Comm7 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
#8
print " 8. Internet Working?\&nbsp\;\&nbsp\;\n";
print "<input type=radio id=spryes8 name=choose8 value=YES><label for=spryes8>YES</label><input type=radio id=sprno8 name=choose8 value=NO>
	   <label for=sprno8>NO</label><input type=radio id=sprna8 name=choose8 value=NA><label for=sprna8>Unknown - N/A</label>\&nbsp\;\&nbsp\;\n";
print "<br><textarea placeholder=Comments name=Comm8 cols=90 rows=1 id=Comm8 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br><br>\n";
print "</font>";
print "</th></tr>\n";

# TABLE 3
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>Additional Comments</font><font size=2 color=blue><i>\&nbsp\;\&nbsp\;Brief summary of current situation - expected outage times, major observations, etc.</font></i>\n";
print "<br><textarea placeholder=Comments name=Comm9 cols=90 rows=3 id=Comm9 onkeyup=\"AutoGrowTextArea(this)\"></textarea><br>\n";
print "</th></tr>\n";

# TABLE 4
print "<tr><th style=text-align:left>\n";
print "<FONT SIZE = 3 color = Black>POC</font>\&nbsp\;\&nbsp\;\n";
print "<input placeholder=Point_of_Contact id=sprpoc name=sprpoc size=75 type=text>\n";
print "</th></tr>\n";
print "</table>";

print "<br><input type=submit>\&nbsp\;\&nbsp\;\n";
print "<input type=reset>\n";
print "\&nbsp\;\&nbsp\;<input type=button style=background-color:#FFCC33 onClick=\"location.href=\'index.pl\'\" value=\'Main Menu\'></b>";
print "</form></center>";

print "<br><br><br><br></body></html>\n";

exit;

}

#FORM TEXT
sub text {
print "Content-type: text/html\n\n";
print "<html><head><title>TEXT MESSAGE</title></head>\n";
print "<body><FONT SIZE = 5><b>TEXT MESSAGE</b></FONT><br><br>\n";
print "<FONT SIZE = 2 color = Black>TEXT MESSAGE GOES HERE</font>\&nbsp\;\&nbsp\;\n";
print "</body></html>\n";
exit;
}

