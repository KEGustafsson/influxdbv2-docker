#!/bin/bash

mkdir -p $PWD/volume/influxdbv2
mkdir -p $PWD/volume/grafana/data
mkdir -p $PWD/volume/grafana/conf
mkdir -p $PWD/volume/telegraf
cp $PWD/telegraf.conf $PWD/volume/telegraf/telegraf.conf

echo "Select Influxdb v2 username"
read username
echo
echo "Select Influxdb v2 password, must be 8 char long"
read password
echo
echo "Select Influxdb v2 organization"
read org
echo
echo "Select Influxdb v2 bucket"
read bucket
echo

docker-compose pull
docker-compose up --no-start
docker-compose start influxdbv2_test &

sleep 10

x=$(curl -X POST http://localhost:8087/api/v2/setup -H 'Content-Type: application/json' -d '{"username": "'$username'","password": "'$password'","org": "'$org'","bucket": "'$bucket'","retentionPeriodHrs": 0}')
echo $x

a=$(echo $x | jq '.auth.token')
b=$(echo $x | jq '.org.name')
c=$(echo $x | jq '.bucket.name')

cat $PWD/volume/telegraf/telegraf.conf

sed -i "s#\"\$INFLUX_TOKEN\"#$a#g" $PWD/volume/telegraf/telegraf.conf
sed -i "s#\"\$ORG\"#$b#g" $PWD/volume/telegraf/telegraf.conf
sed -i "s#\"\$BUCKET\"#$c#g" $PWD/volume/telegraf/telegraf.conf

echo
cat $PWD/volume/telegraf/telegraf.conf

docker run --name grafana_files grafana/grafana:latest &
sleep 30
docker cp grafana_files:/var/lib/grafana/. $PWD/volume/grafana/data
docker cp grafana_files:/usr/share/grafana/conf/. $PWD/volume/grafana/conf
docker stop grafana_files
docker rm grafana_files

docker-compose down
docker-compose up -d
