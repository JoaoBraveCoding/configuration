.PHONY: all
all: generate

.PHONY: generate
generate: prometheusrules servicemonitors grafana slos

.PHONY: prometheusrules
prometheusrules: resources/observability/prometheusrules

resources/observability/prometheusrules: prometheusrules.jsonnet
	jsonnetfmt -i prometheusrules.jsonnet
	jsonnet -J vendor -m resources/observability/prometheusrules prometheusrules.jsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml -- {}; rm -rf {}' -- {}

.PHONY: servicemonitors
servicemonitors: resources/observability/servicemonitors

resources/observability/servicemonitors: servicemonitors.jsonnet
	jsonnetfmt -i servicemonitors.jsonnet
	jsonnet -J vendor -m resources/observability/servicemonitors servicemonitors.jsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml -- {}; rm -rf {}' -- {}

.PHONY: grafana
grafana: resources/observability/grafana

resources/observability/grafana: grafana.jsonnet
	jsonnetfmt -i grafana.jsonnet
	jsonnet -J vendor -m resources/observability/grafana grafana.jsonnet | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml -- {}; rm -rf {}' -- {}

.PHONY: slos
slos: resources/observability/slo/observatorium.slo.yaml

resources/observability/slo/observatorium.slo.yaml: slo.jsonnet
	jsonnetfmt -i slo.jsonnet
	jsonnet -J vendor slo.jsonnet | gojsontoyaml > resources/observability/slo/observatorium.slo.yaml
