#!C:\Perl64\bin
# run by
#  perl cronfn.pl<cron.dat
# in C:\Users\Dave\Documents\Perl
#
# Reports on when cron entries will run
# differentiating between days of the week (a 7-char matrix)
# and a date ( one entry for each dd/mm combination
#

# Function Definitions
#
# Split fields
# min value, max value, date parameter
sub fnExpand{
  @values="";
  @value=split(',',$_[2]);

  $j=0;
  for ($i=0; $i<=$#value; $i++) {
    if ( $value[$i]=~/.*\-.*/ ) {
      @rr=split('-',$value[$i]);
      for($k=$rr[0];$k<=$rr[1];$k++) {
        $values[$j]=$k;
        $j++;
      }
    }
    else {
      if ( $value[$i]=~/\*/ ) {
        for($k=$_[0];$k<=$_[1];$k++) {
          $values[$j]=$k;
          $j++;
        }
      }
      else {
        $values[$j]=$value[$i];
        $j++;
      }
    }
  }
}

# Main Body
#==========
# convert each range into indepedent extra segments - what about *
# sort segments into sequence
# for each day do for each hour for each minute display job
# for each month for for each date do for each hour for each minute display job

$count = 0;
while (<stdin>) {
# grab the parameters for what is being run
  @w = split;
  $com="";
  for ($i=5; $i<=$#w; $i++) {
     $com="$com $w[$i]";
  }

#Process date and time
  @mins="";
  fnExpand(0,59,$w[0]);
  @mins=@values;
  @hors="";
  fnExpand(0,24,$w[1]);
  @hors=@values;
  $by_day=0;
  $by_date=0;

  if ( ($w[2]=~/\*/) && ($w[3]=~/\*/) ){
    $by_day=1;
  } else {
    $by_date=1;
    unless ( $w[4]=~/\*/ ) {
      $by_day=1;
    }
  }


 
  @dats="";
  @mons="";
  if ( $by_date==1 ) {
    fnExpand(1,31,$w[2]);
    @dats=@values;
    fnExpand(1,12,$w[3]);
    @mons=@values;
  } else {
    $dats[0]="\*";
    $mons[0]="\*";
  }

  @days="";
  if( $by_day==1 ) {
    fnExpand(0,6,$w[4]);
    @days=@values;
  } else {
    @days=(0,1,2,3,4,5,6);
  }



# if by day agregate and convert to positions then print single line
# if by date print single line for each entry 

  @dow=("S","M","T","W","t","F","s");
  @dows=(" "," "," "," "," "," "," ");
  for ($i=0; $i<=$#days; $i++) {
    $dows[$days[$i]]=$dow[$days[$i]];
  }

  if( $by_day==1 ) {
    for ($b=0; $b<=$#hors; $b++) {
      for ($a=0; $a<=$#mins; $a++) {
        print join("", "$hors[$b] $mins[$a] (", @dows, ") $com\n");
      }
    }
  }  

  if( $by_date==1) {
    for ($d=0; $d<=$#dats; $d++) {
      for ($c=0; $c<=$#mons; $c++) {
        for ($b=0; $b<=$#hors; $b++) {
          for ($a=0; $a<=$#mins; $a++) {
            print join("", "$hors[$b] $mins[$a] ( $dats[$d] $mons[$c] ) $com\n");
          }
        } 
      }
    }
  }

}