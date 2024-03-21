package registry

import (
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// customRegistry exposes our metrics only.
// We use customRegistry to get rid of all default Prometheus go-client metrics
var customRegistry = prometheus.NewRegistry()

// Register registers the provided Collector with the customRegistry
func Register(collector prometheus.Collector) {
	customRegistry.MustRegister(collector)
}

// Handler returns an http.Handler for customRegistry, using default HandlerOpts
func Handler() http.Handler {
	return promhttp.HandlerFor(customRegistry, promhttp.HandlerOpts{})
}
