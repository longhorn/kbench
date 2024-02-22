{{/*
Expand the name of the chart.
*/}}
{{- define "fio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fio.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fio.labels" -}}
helm.sh/chart: {{ include "fio.chart" . }}
{{ include "fio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fio.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fio.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Pre-calculate PVC size from benchmark size
*/}}
{{- define "fio.pvcSize" -}}
{{- if not (kindIs "string" .Values.benchmark.size) }}
{{- fail "Benchmark size must be of format <size>G, e.g. 10G, 25G, 1000G" -}}
{{- end }}
{{- if not (hasSuffix "G" .Values.benchmark.size) -}}
{{- fail "Benchmark size must be of format <size>G, e.g. 10G, 25G, 1000G" -}}
{{- end}}
{{- $sizeElevenX := mul (trimSuffix "G" .Values.benchmark.size) 11 -}}
{{- if (ne (mod $sizeElevenX 10) 0) -}}
{{- add1 (div $sizeElevenX 10) }}Gi
{{- else -}}
{{- div $sizeElevenX 10 }}Gi
{{- end }}
{{- end }}
