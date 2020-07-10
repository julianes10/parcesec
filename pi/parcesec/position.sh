#BASE_URL="http://localhost:5070/api/v1.0/picam"
BASE_URL="http://192.168.1.44:5070/api/v1.0/picam"

e=$1

d="+"
if [ "$#" -gt 1 ]; then
  d=$2
fi




generate_post_data()
{
if [ "$d" == "+++" ]
then
cat <<EOF
{ "$e": { "delta" : "25" } }
EOF
elif [ "$d" == "++" ]
then
cat <<EOF
{ "$e": { "delta" : "10" } }
EOF
elif [ "$d" == "+ee" ]
then
cat <<EOF
{ "$e": { "delta" : "5" } }
EOF
elif [ "$d" == "---" ]
then
cat <<EOF
{ "$e": { "delta" : "-25" } }
EOF
elif [ "$d" == "--" ]
then
cat <<EOF
{ "$e": { "delta" : "-10" } }
EOF
elif [ "$d" == "-" ]
then
cat <<EOF
{ "$e": { "delta" : "-5" } }
EOF
else
cat <<EOF
{ "$e": { "abs" : $d } }
EOF
fi
}

#Launch movement
curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" $BASE_URL/position > /dev/null 2>&1


