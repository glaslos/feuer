package main

import (
	"net/http"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	recordMetrics()

	http.Handle("/metrics", logMiddleware(promhttp.Handler()))
	http.ListenAndServe(":2112", nil)
}
