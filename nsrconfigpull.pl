#!/usr/bin/perl

$group = "<SAVE GROUP NAME>";
$server = "<NETWORKER SERVER NAME>";

$cmd = "echo -e \"option regexp\nshow name;comment;scheduled backup;schedule;group;save set;backup command\np type:NSR Client;scheduled backup:Enabled;group:$group;\" | nsradmin -s $server -i - ";

@output = ` $cmd`;

splice @output, 0, 8;

my %config = ();
$i = 0;
foreach (@output) {
  $cleanline = trim($_);
  $cleanline =~ s/;//g;
  $cleanline =~ s/\R//g;
  if ($cleanline =~ m/name:/) { $i = $i + 1; }
  @split = split(":",$cleanline,2);
  $config{ $i }{ $split[0] } = trim($split[1]);
}

for (my $x = 0; $x <= $i; $x++) {
  if ($config{$x}{"name"} eq "") { next; }
  if ($config{$x}{"name"} =~ m/aprac/) { next; }
  $name = $config{$x}{"name"};
  $comment = $config{$x}{"comment"};
  $status = $config{$x}{"scheduled backup"};
  $schedule = $config{$x}{"schedule"};
  $group = $config{$x}{"group"};
  $saveset = $config{$x}{"save set"};
  $saveset =~ s/^"(.*)"$/$1/;
  $backupcmd = $config{$x}{"backup command"};
  $createcmd = "echo -e \"create type:NSR Client;name:$name;comment:$comment;scheduled backup:$status;group:Test;save set:\\\"$saveset\\\";backup command:$backupcmd\" | nsradmin -i -";
  print $createcmd . "\n";
}

#trim functions
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
