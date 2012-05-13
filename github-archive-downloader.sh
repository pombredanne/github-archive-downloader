#!/bin/sh

WGET="wget -t 0 -N"
OUTPUT="archive"
GZIP="gzip -d"
BASE="http://data.githubarchive.org"
EXTENSION="json.gz"

mkdir -p $OUTPUT

download() {
    $WGET -P $OUTPUT $BASE/$1-$2-$3.$EXTENSION
}

DEFAULT_STARTS="2012-03-11"
DEFAULT_ENDS=$(date +%Y-%m-%d)

unset TEXT
echo -n "Starting date [$DEFAULT_STARTS]: "
read TEXT
if [ -z ${TEXT} ]; 
then
    STARTS=$DEFAULT_STARTS
else
    STARTS=$TEXT
fi
echo "Seting starting date to $STARTS"

unset TEXT
echo -n "Ending date [$DEFAULT_ENDS]: "
read TEXT
if [ -z ${TEXT} ]; 
then
    ENDS=$DEFAULT_ENDS
else
    ENDS=$TEXT
fi
echo "Seting ending date to $ENDS"

#DATE_STARTS=$(date -d $STARTS)
#DATE_ENDS=$(date -d $ENDS)
#if ( $DATE_ENDS < $DATE_STARTS ); 
#then
#    echo "invalid range of dates!"
#    exit
#fi

STARTS_YEAR=`echo $STARTS | awk -F- '{print $1}'`
STARTS_MONTH=`echo $STARTS | awk -F- '{print $2}'`
STARTS_DAY=`echo $STARTS | awk -F- '{print $3}'`
ENDS_YEAR=`echo $ENDS | awk -F- '{print $1}'`
ENDS_MONTH=`echo $ENDS | awk -F- '{print $2}'`
ENDS_DAY=`echo $ENDS | awk -F- '{print $3}'`

for YEAR in $(seq $STARTS_YEAR $ENDS_YEAR);
do
    for DAY in $(seq $STARTS_DAY 30); #FIXME: will fail when the archive has more years
    do
        download $YEAR $STARTS_MONTH $DAY
    done
    for MONTH in $(seq $((STARTS_MONTH+1)) $((ENDS_MONTH-1)));
    do
        for DAY in $(seq 1 30); #FIXME: months with 31
        do
            download $YEAR $MONTH $DAY
        done
    done
    for DAY in $(seq 1 $ENDS_DAY); #FIXME: will fail when the archive has more years
    do
        download $YEAR $ENDS_MONTH $DAY
    done
done 

