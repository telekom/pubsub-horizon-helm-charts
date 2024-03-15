{{/*
Expand the name of the chart.
*/}}
{{- define "horizon.galaxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "horizon.galaxy.fullname" -}}
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
{{- define "horizon.galaxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "horizon.galaxy.labels" -}}
app: {{ include "horizon.galaxy.name" . }}
helm.sh/chart: {{ include "horizon.galaxy.chart" . }}
{{ include "horizon.galaxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/component: galaxy
app.kubernetes.io/part-of: horizon
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "horizon.galaxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horizon.galaxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.galaxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "horizon.galaxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.galaxy.affinity" -}}
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
              - {{ include "horizon.galaxy.name" . }}
      topologyKey: kubernetes.io/hostname
      namespaces: 
        - {{ .Release.Namespace }}
{{- end }}
{{- end }}