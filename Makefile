HOME = $(shell pwd)
DOCKER = docker run --net host -it --rm

server:
	go run *.go

grafana:
	$(DOCKER) -p 3000:3000 -v $(HOME)/datasources.yml:/etc/grafana/provisioning/datasources/datasources.yml grafana/grafana:latest

prometheus:
	$(DOCKER) -p 9090:9090 -v $(HOME)/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

influxdb:
	$(DOCKER) -p 8086:8086 quay.io/influxdb/influxdb:v2.0.3

telegraf:
	$(DOCKER) -v $(HOME)/telegraf.conf:/etc/telegraf/telegraf.conf telegraf

promtail:
	$(DOCKER) -v $(HOME)/promtail.yml:/mnt/config/promtail.yml -v $(HOME)/logs:/mnt/logs grafana/promtail:2.6.1 -config.file=/mnt/config/promtail.yml

loki:
	$(DOCKER) -v $(HOME)/loki.yml:/mnt/config/loki.yml -p 3100:3100 grafana/loki:2.6.1 -config.file=/mnt/config/loki.yml
