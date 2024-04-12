{{/* Expand the name of the chart. */}}
{{- define "my-application.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "my-application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create the name of the release. */}}
{{- define "my-application.fullname" -}}
{{- if .Release.Name }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{/* Common labels */}}
{{- define "my-application.labels" -}}
app.kubernetes.io/name: {{ include "my-application.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Define selector labels */}}
{{- define "my-application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-application.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}