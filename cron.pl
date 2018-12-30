#!C:\Perl64\bin
# run by
#  perl cron.pl<cron.dat
# in C:\Users\Dave\Documents\Perl
#
# Takes cron schedule and expands the entries to everytime they would run
# by expanding * and - as necessary
#
$count = 0;
while (<stdin>) {
  @w = split;

# break down by comma into segments
  @min=split(',',$w[0]);
  @hor=split(',',$w[1]);
  @dat=split(',',$w[2]);
  @mon=split(',',$w[3]);
  @day=split(',',$w[4]);

# convert each range into indepedent extra segments - what about *
# sort segments into sequence
# for each day do for each hour for each minute display job
# for each month for for each date do for each hour for each minute display job
#line 24

  $com="";
  for ($i=5; $i<=$#w; $i++) {
     $com="$com $w[$i]";
  }

  @mins="";
  $j=0;
  for ($i=0; $i<=$#min; $i++) {
    if ( $min[$i]=~/.*\-.*/ ) {
      @rr=split('-',$min[$i]);
      for($k=$rr[0];$k<=$rr[1];$k++) {
        $mins[$j]=$k;
        $j++;
      }
    }
    else {
      if ( $min[$i]=~/\*/ ) {
        for($k=0;$k<=59;$k++) {
          $mins[$j]=$k;
          $j++;
        }
      }
      else {
        $mins[$j]=$min[$i];
        $j++;
      }
    }
  }
#line 54
  @hors="";
  $j=0;
  for ($i=0; $i<=$#hor; $i++) {
    if ( $hor[$i]=~/.*\-.*/ ) {
      @rr=split('-',$hor[$i]);
      for($k=$rr[0];$k<=$rr[1];$k++) {
        $hors[$j]=$k;
        $j++;
      }
    }
    else {
      if ( $hor[$i]=~/\*/ ) {
        for($k=0;$k<=24;$k++) {
          $hors[$j]=$k;
          $j++;
        }
      }
      else {
        $hors[$j]=$hor[$i];
        $j++;
      }
    }
  }
#line 78
  $by_day=0;
  $by_date=0;
  if ( $day[0]=~/\*/ ) {
    $by_date=1;
  }
  else {
    $by_day=1;
    unless ( ($dat[0]=~/\*/) && ($mon[0]=~/\*/) ){
      $by_date=1;
    }
  }
#line 90

  @dats="";
  @mons="";
  if ( $by_date==1 ) {
    $j=0;
    for ($i=0; $i<=$#dat; $i++) {
      if ( $dat[$i]=~/.*\-.*/ ) {
        @rr=split('-',$dat[$i]);
        for($k=$rr[0];$k<=$rr[1];$k++) {
          $dats[$j]=$k;
          $j++;
        }
      }
      else {
        if ( $dat[$i]=~/\*/ ) {
          for($k=1;$k<=31;$k++) {
            $dats[$j]=$k;
            $j++;
          }
        }
        else {
          $dats[$j]=$dat[$i];
          $j++;
        }
      }
    }

    $j=0;
    for ($i=0; $i<=$#mon; $i++) {
      if ( $mon[$i]=~/.*\-.*/ ) {
       @rr=split('-',$mon[$i]);
        for($k=$rr[0];$k<=$rr[1];$k++) {
          $mons[$j]=$k;
          $j++;
        }
      }
      else {
        if ( $mon[$i]=~/\*/ ) {
          for($k=1;$k<=12;$k++) {
            $mons[$j]=$k;
            $j++;
          }
        }
        else {
          $mons[$j]=$mon[$i];
          $j++;
        }
      }
    }
  }
  else {
    $dats[0]="\*";
    $mons[0]="\*";
  }


  @days="";
  if( $by_day==1 ) {
    $j=0;
    if ( $day[0]=~/\*/ ) {
      $days[0]=$day[0];
    }
    else {
      for ($i=0; $i<=$#day; $i++) {
        if ( $day[$i]=~/.*\-.*/ ) {
          @rr=split('-',$day[$i]);
          for($k=$rr[0];$k<=$rr[1];$k++) {
            $days[$j]=$k;
            $j++;
          }
        }
        else {
          $days[$j]=$day[$i];
          $j++;
        }
      }
    }
  }
  else {
    $days[0]="\*";
  }

# if by day agregate and convert to positions then print single line
# if by date print single line for each entry 

  for ($e=0; $e<=$#days; $e++) {
    for ($d=0; $d<=$#dats; $d++) {
      for ($c=0; $c<=$#mons; $c++) {
        for ($b=0; $b<=$#hors; $b++) {
          for ($a=0; $a<=$#mins; $a++) {
            print "$dats[$d]/$mons[$c]_$hors[$b]:$mins[$a] ($days[$e]) does$com\n";
          }
        } 
      }
    }
  }

}