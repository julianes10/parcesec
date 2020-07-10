BASE_URL="http://localhost:5070/api/v1.0/picam"
#BASE_URL="http://192.168.1.44:5070/api/v1.0/picam"


op=$1
of=$2
t=5
if [ "$#" -gt 2 ]; then
  t=$3
fi


tms=$(( t*1000*2 ))

generate_post_data()
{
if [ "$op" == "p" ]
then
cat <<EOF
{ "backPosition":true, 
   "data": [ {  "backPosition" : true, 
       "pan": { "ini":0, "end": 180}, 
       "tilt": { "ini": 65, "end": 65}, 
       "duration" : $t, 
       "reverse": true, 
        "ntimes" : 1 }] 
}
EOF
else
cat <<EOF
{ "backPosition":true, 
   "data": [ {  "backPosition" : true, 
       "pan": { "ini":90, "end": 90}, 
       "tilt": { "ini": 0, "end": 90}, 
       "duration" : $t, 
       "reverse": true, 
        "ntimes" : 1 }] 
}
EOF
fi
}



#echo "Taking a look around..."
#Preventive cleanup
rm -f $of  > /dev/null 2>&1
rm -f /tmp/video.h264 > /dev/null 2>&1

#Launch capture
relaunch=0
sudo systemctl status mjpg-streamer.service > /dev/null 2>&1
if [ $? -eq 0 ]
then
  # echo "Stopping live streaming..."
  sudo systemctl stop mjpg-streamer.service > /dev/null 2>&1
  relaunch=1
fi

#Launch movement
curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" $BASE_URL/track > /dev/null 2>&1


/opt/parcesec/picam/raspividForce.sh -t $tms -w 320 -h 240 -awb auto -ex auto -o /tmp/video.h264 > /dev/null 2>&1


#raspistill -t $tms -w 320 -h 240 -awb auto -ex auto -o /tmp/video.h264 > /dev/null 2>&1
aux=$?
if [ ! $aux -eq 0 ]
then
   echo "#### ERROR taking photo ####"
fi
  

if [ $relaunch -eq 1 ]
then
    #echo "Restoring live streaming..."
    sudo systemctl start mjpg-streamer.service > /dev/null 2>&1
fi

# Wrap the raw video with an MP4 container: 
MP4Box -add /tmp/video.h264 $of > /dev/null 2>&1
#> /dev/null 2>&1


