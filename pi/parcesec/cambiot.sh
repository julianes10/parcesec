BASE_URL="http://localhost:5161/api/v1.0/telegramBOT"

TEMP=$(cat /var/dht.t | awk '{print $NF}' | tail -1)

op=$1
of=$2
t=5
if [ "$#" -gt 2 ]; then
  t=$3
fi


tms=$(( t*1000*2 ))

generate_post_data()
{
cat <<EOF
{ "name":"cambiot2"} 
EOF
}

function sendEvent()
{
curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" $BASE_URL/event > /dev/null 2>&1
}

tempBefore=$TEMP
do
  logger  "$0 - Cambiot looping"  
  tempNow=$TEMP
  logger  "$0 - Cambiot looping. Temperature now $tempNow. Previous temperature $tempBefore"
  offset_temp=`$tempBefore - $tempNow" | sed 's/\+//g' | bc`

TODO tempBefore +- 2grados debe disparar el evento
seria bueno informar de las fechas.
  if [ -f $MARK ];then
    logger  "$0 - The egg is here. Executing it"
    rm -f $MARK
    cd $OUTPATH
    ./$SUPERNOVA
    rt=`echo $?`
    logger  "$0 - The egg core is executed, exit code $rt"
    logger  "$0 - Waiting for the new egg"
  fi
	sleep 1
done




