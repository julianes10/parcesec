t=1
min="false"
hour="false"
sec="false"

if [ "$#" -gt 1 ]; then
  t=$2
fi

# Args while-loop
while [ $# -gt 0 ];
do
   case "$1" in
   -m  | --minutes ) 
                   min="true"
			             ;;
   -s  | --seconds ) 
                   sec="true"
			             ;;
   -h  | --hours ) 
                   hour="true"
			$             ;;
    esac
    shift
done



/opt/parcesec/gpio/gpio.py --pin 17 --value 1
/opt/parcesec/telegramBOT/sendEventWrapper.sh -e light -t "Light ON for $t [$hour:$min:$sec]" 

if [ $hour == "true" ]; then
  sleep $(( t*3600 ))
elif [ $min == "true" ]; then
  sleep $(( t*60 ))
else
  sleep $t
fi

/opt/parcesec/gpio/gpio.py --pin 17 --value 0

/opt/parcesec/telegramBOT/sendEventWrapper.sh -e light -t "Light OFF after $t [$hour:$min:$sec]" 


