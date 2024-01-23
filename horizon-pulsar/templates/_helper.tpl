{{- define "horizon.pulsar.labels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: horizon-pulsar
app.kubernetes.io/instance: {{ .Release.Name }}-app
app.kubernetes.io/component: app
app.kubernetes.io/part-of: pubsub
eni.telekom.de/component: sse
{{- end -}}

{{- define "horizon.pulsar.selector" -}}
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

{{- define "horizon.pulsar.host" -}}
    {{- if not (empty .Values.ingress.hostname) }}
        {{- .Values.ingress.hostname -}}
   {{- else -}}
        {{- $prefix := "" -}}
        {{- printf "%s-%s%s.%s" .Release.Name $prefix .Release.Namespace .Values.common.domain }}
    {{- end -}}
{{- end -}}

{{- define "horizon.pulsar.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.pulsar.volumeMounts" -}}
- mountPath: /tmp
  name: tmp
{{- end -}}

{{- define "horizon.pulsar.image" -}}
{{- $imageName := "pulsar" -}}
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

{{- define "horizon.pulsar.envs" -}}
- name: SPRING_PROFILES_ACTIVE
  value: "prod"
- name: LOG_LEVEL
  value: {{ .Values.commonHorizon.logLevel | quote }}
- name: HORIZON_LOG_LEVEL
  value: {{ .Values.commonHorizon.horizonLogLevel | quote }}
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
    --add-modules=java.se
    --add-exports=java.base/jdk.internal.ref=ALL-UNNAMED
    --add-opens=java.base/java.lang=ALL-UNNAMED
    --add-opens=java.management/sun.management=ALL-UNNAMED
    --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
{{- else }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
    --add-modules=java.se
    --add-exports=java.base/jdk.internal.ref=ALL-UNNAMED
    --add-opens=java.base/java.lang=ALL-UNNAMED
    --add-opens=java.management/sun.management=ALL-UNNAMED
    --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
{{- end }}
- name: {{ .Values.image.name | upper }}_ISSUER_URL
  value: {{ .Values.commonHorizon.issuerUrl | quote }}
- name: {{ .Values.image.name | upper }}_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ .Values.image.name | upper }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ .Values.image.name | upper }}_FEATURE_SUBSCRIBER_CHECK
  value: {{ .Values.pulsar.features.subscriberCheck | quote }}
- name: {{ .Values.image.name | upper }}_SSE_POLL_DELAY
  value: {{ .Values.pulsar.ssePollDelay | quote }}
- name: {{ .Values.image.name | upper }}_SSE_TIMEOUT
  value: {{ .Values.pulsar.sseTimeout | quote }}
- name: {{ .Values.image.name | upper }}_SSE_BATCH_SIZE
  value: {{ .Values.pulsar.sseBatchSize | quote }}
- name: {{ .Values.image.name | upper }}_THREADPOOL_SIZE
  value: {{ .Values.pulsar.threadPoolSize | quote }}
- name: {{ .Values.image.name | upper }}_QUEUE_CAPACITY
  value: {{ .Values.pulsar.queueCapacity | quote }}
- name: {{ .Values.common.product | upper}}_MONGO_CLIENTID
  value: {{ .Values.pulsar.mongo.clientId | quote }}
- name: {{ .Values.common.product | upper}}_MONGO_URL
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-mongo
      key: mongoUrl
- name: {{ .Values.image.name | upper }}_SECURITY_OAUTH
  value: {{ .Values.pulsar.oauthEnabled | default true | toString | quote }}
- name: {{ .Values.image.name | upper }}_CACHE_DE_DUPLICATION_ENABLED
  value: {{ .Values.pulsar.cache.deDuplication.enabled | quote }}
- name: {{ .Values.image.name | upper }}_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
{{- end -}}
