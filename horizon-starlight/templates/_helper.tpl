{{- define "horizon.starlight.labels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: horizon-starlight
app.kubernetes.io/instance: {{ .Release.Name }}-app
app.kubernetes.io/component: app
app.kubernetes.io/part-of: pubsub
{{- end -}}

{{- define "horizon.starlight.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}-app
{{- end -}}

{{- define "horizon.ingress.labels" -}}
    {{- if eq (toString .Values.ingress.isCaaS) "true"}}
        kubernetes.io/ingress.class: nginx
    {{- else }}
        kubernetes.io/ingress.class: triton-ingress
    {{- end }}
kubernetes.io/tls-acme: "true"
nginx.ingress.kubernetes.io/backend-protocol: HTTP
nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
{{- end -}}

{{- define "horizon.starlight.host" -}}
    {{- if not (empty .Values.ingress.hostname) }}
        {{- .Values.ingress.hostname -}}
    {{- else -}}
        {{- $prefix := "" -}}
        {{- printf "%s-%s%s.%s" .Release.Name $prefix .Release.Namespace .Values.common.domain }}
    {{- end -}}
{{- end -}}

{{- define "horizon.starlight.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.starlight.volumeMounts" -}}
- mountPath: /tmp
  name: tmp
{{- end -}}

{{- define "horizon.starlight.image" -}}
{{- $imageName := "starlight" -}}
{{- $imageTag := "develop" -}}
{{- $imageRepository := "example.devops.company.de" -}}
{{- $imageOrganization := "internal/example/horizon" -}}
{{- if .Values.image -}}
  {{- if not (kindIs "string" .Values.image) -}}
    {{ $imageRepository = .Values.image.repository | default $imageRepository -}}
    {{ $imageOrganization = .Values.image.organization | default $imageOrganization -}}
    {{ $imageName = .Values.image.name | default $imageName -}}
    {{ $imageTag = .Values.image.tag | default $imageTag -}}
    {{- printf "%s/%s/%s:%s" $imageRepository $imageOrganization $imageName $imageTag -}}
  {{- else -}}
    {{- .Values.image -}}
  {{- end -}}
{{- else -}}
 {{- printf "%s/%s/%s:%s" $imageRepository $imageOrganization $imageName $imageTag -}}
{{- end -}}
{{- end -}}

{{- define "horizon.starlight.envs" -}}
- name: SPRING_PROFILES_ACTIVE
  value: "prod"
- name: LOG_LEVEL
  value: {{ .Values.commonHorizon.logLevel | quote }}
- name: JAVA_TOOL_OPTIONS
{{- if eq (toString .Values.commonHorizon.jmxRemote.enabled) "true" }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
    -Dcom.sun.management.jmxremote.local.only=false
    -Dcom.sun.management.jmxremote.port=9010
    -Dcom.sun.management.jmxremote.rmi.port=9010
    -Djava.rmi.server.hostname=127.0.0.1
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
{{- else }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
{{- end }}
- name: {{ .Values.image.name | upper }}_ISSUER_URL
  value: {{ .Values.commonHorizon.issuerUrl | quote }}
- name: {{ .Values.image.name | upper }}_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: {{ .Values.image.name | upper }}_PUBLISHING_TIMEOUT_MS
  value: {{ .Values.commonHorizon.publishingTimeoutMs | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ .Values.image.name | upper }}_FEATURE_PUBLISHER_CHECK
  value: {{ .Values.starlight.features.publisherCheck | quote }}
- name: {{ .Values.image.name | upper }}_FEATURE_SCHEMA_VALIDATION
  value: {{ .Values.starlight.features.schemaValidation | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_TRANSACTION_PREFIX
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
{{- if .Values.starlight.features.customPublishingTopics }}
- name: {{ .Values.image.name | upper }}_CUSTOM_PUBLISHING_TOPICS
  value: |
    {{- toYaml .Values.starlight.features.customPublishingTopics | nindent 4 }}
{{- end }}
- name: IRIS_ISSUER_URL
  value: {{ .Values.starlight.oidc.issuerUrl | toString | quote }}
- name: CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-oidc
      key: clientId
- name: CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-oidc
      key: clientSecret
- name: ENIAPI_BASEURL
  value: {{ .Values.starlight.eniapi.baseurl | toString | quote }}
- name: {{ .Values.common.team | upper }}_TRACING_DEBUGENABLED
  value: {{ .Values.commonHorizon.tracing.debugEnabled | quote }}
- name: VICTORIALOG_ENABLED
  value: {{ .Values.commonHorizon.victorialog.enabled | quote }}
- name: VICTORIALOG_COLLECTOR_URL
  value: {{ .Values.commonHorizon.victorialog.collectorUrl | quote }}
- name: VICTORIALOG_CLIENT_ID
  value: {{ .Values.commonHorizon.victorialog.clientId | quote }}
- name: VICTORIALOG_BATCH_SIZE
  value: {{ .Values.commonHorizon.victorialog.batchSize | quote }}
- name: VICTORIALOG_OBSERVATION_FLUSH_INTERVAL
  value: {{ .Values.commonHorizon.victorialog.observationFlushInterval | quote }}
- name: VICTORIALOG_COUNT_EVENTS_INTERVAL
  value: {{ .Values.commonHorizon.victorialog.countEventsInterval| quote }}
- name: VICTORIALOG_SAMPLING_RATE
  value: {{ .Values.commonHorizon.victorialog.samplingRate | quote }}
- name: {{ .Values.image.name | upper }}_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
{{- end -}}


