BASE_URL="http://localhost:5070/api/v1.0/picam"
#BASE_URL="http://192.168.1.44:5070/api/v1.0/picam"

t=3
of=$1

if [ "$#" -gt 1 ]; then
  t=$2
fi


tms=$(( t*1000 ))
rm -f /tmp/video.h264
rm -f $of > /dev/null 2>&1

/opt/parcesec/picam/raspividForce.sh -t $tms -w 320 -h 240 -awb auto -ex auto -o /tmp/video.h264 > /dev/null 2>&1

MP4Box -add /tmp/video.h264 $of > /dev/null 2>&1




