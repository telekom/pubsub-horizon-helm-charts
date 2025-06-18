{{/*
Expand the name of the chart.
*/}}
{{- define "horizon.pulsar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "horizon.pulsar.fullname" -}}
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
{{- define "horizon.pulsar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "horizon.pulsar.labels" -}}
app: {{ include "horizon.pulsar.name" . }}
helm.sh/chart: {{ include "horizon.pulsar.chart" . }}
{{ include "horizon.pulsar.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/component: pulsar
app.kubernetes.io/part-of: horizon
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "horizon.pulsar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horizon.pulsar.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.pulsar.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "horizon.pulsar.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.pulsar.affinity" -}}
{{- if .Values.affinity }}
{{- .Values.affinity | toYaml }}
{{- else -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
              - kafka
              - {{ include "horizon.pulsar.name" . }}
      topologyKey: kubernetes.io/hostname
      namespaces: 
        - {{ .Release.Namespace }}
{{- end }}
{{- end }}