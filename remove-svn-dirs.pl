#!/usr/bin/perl -w

################################################################################
# DESCRIPTION
################################################################################
# This script takes one argument from the command line. That argument should
# be the directory to start from.
################################################################################

################################################################################
# CALLS
################################################################################

use strict;
use File::Find;
use File::Path;

################################################################################
# MAIN
################################################################################

### unbuffer output
$|=1;

### make sure an argument was passed
if(!defined($ARGV[0]))
{
  &noArgError();
}
elsif(!-d $ARGV[0])
{
  &notDirError();
}
else
{
  my $topDir = $ARGV[0];
  printf("Removing .svn directories from: %s\n", $topDir);
  find(\&killSvnDirs, $topDir);
}



################################################################################
# SUBS
################################################################################


################################################################################
# &killSvnDirs()
# The meat of the script that looks does the actual removal of the .svn
# .svn directories. 
################################################################################

sub killSvnDirs
{
  my $chkName = $_;
  my $chkPath = $File::Find::name;
  if($chkName eq '.svn')
  {
    if(-d $chkPath)
    {
      if(rmtree($chkPath))
      {
        printf("Removed: %s\n", $chkPath);
      }
      else
      {
        printf("ERROR - Could not remove: %s\n", $chkPath);
      }
      
      ### prune the direcotry so File::Find doesn't try parse it.
      $File::Find::prune = 1;
      
    } 
  }
}

################################################################################
# &noArgError();
# Prints out the message for no argument passed to the script, then exists.
################################################################################

sub noArgError
{
  print <<EOP;
Usage: 
  remove-svn-dirs.pl DIRECTORY

ERROR: You must pass a directory to this script.
  
EOP
  exit;
}

################################################################################
# &notDirError();
# Prints out the message for no argument passed to the script, then exists.
################################################################################

sub notDirError
{
  print <<EOP;
Usage: 
  remove-svn-dirs.pl DIRECTORY

ERROR: The argument you passed to the script must be a diretory.

EOP

  exit;
}
 