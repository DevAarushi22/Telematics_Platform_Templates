{{/*
Expand the service name
*/}}
{{- define "microservice.name" -}}
{{- .Values.service.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Full resource name
*/}}
{{- define "microservice.fullname" -}}
{{- printf "%s" .Values.service.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "microservice.labels" -}}
app.kubernetes.io/name: {{ include "microservice.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}