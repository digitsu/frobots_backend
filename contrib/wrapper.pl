#!/usr/bin/perl

open(my $fh,"<","/app/.env") || die "failed: $!";
while(<$fh>){
  if($_=~m#^export\s+([^=]+)\=[\"\']?(.*)[\"\']?#){
     $ENV{$1}=$2;
  }
}
close($fh);
#warn $ENV{ADMIN_USER}."\n";
exec(@ARGV);
#exit(1);

