{{/*
Expand the name of the chart.
*/}}
{{- define "horizon.polaris.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "horizon.polaris.fullname" -}}
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
{{- define "horizon.polaris.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "horizon.polaris.labels" -}}
{{- $base := dict
    "helm.sh/chart" (include "horizon.polaris.chart" .)
    "app.kubernetes.io/managed-by" .Release.Service
}}
{{- if .Chart.AppVersion }}
{{- $_ := set $base "app.kubernetes.io/version" .Chart.AppVersion }}
{{- end }}
{{- $selectorLabels := include "horizon.polaris.selectorLabels" . | fromYaml }}
{{- $extra := .Values.extraLabels | default dict }}
{{- $all := merge $base $selectorLabels $extra }}
{{- range $key, $value := $all }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "horizon.polaris.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horizon.polaris.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.polaris.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "horizon.polaris.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horizon.polaris.affinity" -}}
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
              - {{ include "horizon.polaris.name" . }}
      topologyKey: kubernetes.io/hostname
      namespaces: 
        - {{ .Release.Namespace }}
{{- end }}
{{- end }}