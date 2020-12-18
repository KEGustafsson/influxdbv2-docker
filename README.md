# influxdbv2-docker

Telegraf, Influxdb v2 and Grafana in docker for Signal K testing.

If Signal K is not runnign is same computer, change telegraf.conf setting first. Also if you want to read other path than vessels.self.

Run run_me_1st.sh and enter username, password, org and bucket for Influxdb.

Influxdb port = 8087

Grafana port = 3002

When Influxdb is runnign, generate token from Grafana and add data source (Query Language = Flux).
