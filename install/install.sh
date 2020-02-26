#!/bin/bash 
echo "## STARTING CUSTOM ACTIONS BEFORE INSTALLING"
source ./install/pivars.sh 
echo "Umounting bind folders..."
ssh -p $PI_PORT pi@$PI_IPNAME "sudo umount /opt/parcesec/timelapse/static/tmp/timelapse.media"
ssh -p $PI_PORT pi@$PI_IPNAME "sudo umount /opt/parcesec/parcesec/static/tmp/parcesec.media"

echo "Stopping haproxy.."
ssh -p $PI_PORT pi@$PI_IPNAME "sudo systemctl stop haproxy"

echo "## ENDED CUSTOM ACTIONS BEFORE INSTALLING"


echo "Here we go: $@"
echo "------------------------------------------------------------------"
echo "- This script must me executed from root project                 -"  
echo "- Review install/pivars.sh for specific settings for this projet -"
echo "------------------------------------------------------------------"
cmd="./SCS/utils/deploySoftware.sh ./install/pivars.sh $@"
echo "Executing $cmd"
$cmd
aux=$?
echo "## STARTING CUSTOM ACTIONS AFTER INSTALLING"
echo "Starting haproxy.."
ssh -p $PI_PORT pi@$PI_IPNAME "sudo systemctl start haproxy"
echo "## ENDED CUSTOM ACTIONS AFTER INSTALLING"
exit $aux



