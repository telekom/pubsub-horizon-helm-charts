{{- define "horizon.polaris.labels" -}}
app: {{ .Release.Name }}-polaris
app.kubernetes.io/name: horizon-polaris
app.kubernetes.io/instance: {{ .Release.Name }}-polaris-app
app.kubernetes.io/component: polaris
app.kubernetes.io/part-of: horizon
developer.telekom.de/pubsub/horizon/cache-context: callback
{{- end -}}

{{- define "horizon.polaris.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}-polaris-app
{{- end -}}

{{- define "horizon.polaris.host" -}}
    {{- if not (empty .Values.ingress.hostname) }}
        {{- .Values.ingress.hostname -}}
    {{- else -}}
        {{- $prefix := "" -}}
        {{- printf "%s-%s%s.%s" .Release.Name $prefix .Release.Namespace .Values.common.domain }}
    {{- end -}}
{{- end -}}

{{- define "horizon.polaris.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.polaris.volumeMounts" -}}
- mountPath: /tmp
  name: tmp
{{- end -}}

{{- define "horizon.polaris.image" -}}
{{- $imageName := "polaris" -}}
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

{{- define "horizon.polaris.envs" -}}
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
- name: POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: {{ .Values.common.product | upper}}_CACHE_KUBERNETESSERVICEDNS
  value: {{ .Values.polaris.cache.serviceDNS | quote }}
- name: IRIS_TOKEN_ENDPOINT
  value: {{ .Values.polaris.iris.tokenEndpoint | toString | quote }}
- name: IRIS_CLIENT_ID
  value: {{ .Values.polaris.iris.clientId | toString | quote }}
- name: IRIS_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-polaris-iris
      key: clientSecret
- name: {{ .Values.image.name | upper }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ .Values.image.name | upper }}_MAX_TIMEOUT
  value: {{ .Values.polaris.maxTimeout | quote }}
- name: {{ .Values.image.name | upper }}_MAX_CONNECTIONS
  value: {{ .Values.polaris.maxConnections | quote }}
- name: {{ .Values.image.name | upper }}_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: {{ .Values.image.name | upper }}_PODS_INFORMER_NAMESPACE
  value: {{ .Values.polaris.informer.pods.namespace | quote }}
- name: {{ .Values.image.name | upper }}_APP_NAME
  value: {{ .Release.Name | quote }}
- name: {{ .Values.image.name | upper }}_DELIVERING_STATES_OFFSET_MINS
  value: {{ .Values.polaris.offsetMins.deliveringStates | quote }}
- name: {{ .Values.image.name | upper }}_SUCCESSFUL_STATUS_CODES
  value: {{ .Values.polaris.request.successfulStatusCodes | quote }}
- name: {{ .Values.image.name | upper }}_POLLING_INTERVAL_MS
  value: {{ .Values.polaris.polling.intervalMs | quote }}
- name: {{ .Values.image.name | upper }}_POLLING_BATCH_SIZE
  value: {{ .Values.polaris.polling.batchSize | quote }}
- name: {{ .Values.image.name | upper }}_PICKING_TIMEOUT_MS
  value: {{ .Values.polaris.picking.timeoutMs | quote }}
- name: {{ .Values.image.name | upper }}_REQUEST_COOLDOWN_RESET_MINS
  value: {{ .Values.polaris.request.cooldownResetMins | quote }}
- name: {{ .Values.image.name | upper }}_REQUEST_THREADPOOL_SIZE
  value: {{ .Values.polaris.request.scheduledThreadpool.size | quote }}
- name: {{ .Values.image.name | upper }}_REQUEST_DELAY_MINS
  value: {{ .Values.polaris.request.delayMins | quote }}
- name: {{ .Values.image.name | upper }}_SUBCHECK_THREADPOOL_MAX_SIZE
  value: {{ .Values.polaris.subscriptionCheck.threadpool.maxSize | quote }}
- name: {{ .Values.image.name | upper }}_SUBCHECK_THREADPOOL_CORE_SIZE
  value: {{ .Values.polaris.subscriptionCheck.threadpool.coreSize | quote }}
- name: {{ .Values.image.name | upper }}_SUBCHECK_THREADPOOL_QUEUE_CAPACITY
  value: {{ .Values.polaris.subscriptionCheck.threadpool.queueCapacity | quote }}
- name: {{ .Values.image.name | upper }}_REPUBLISH_THREADPOOL_MAX_SIZE
  value: {{ .Values.polaris.republish.threadpool.maxSize | quote }}
- name: {{ .Values.image.name | upper }}_REPUBLISH_THREADPOOL_CORE_SIZE
  value: {{ .Values.polaris.republish.threadpool.coreSize | quote }}
- name: {{ .Values.image.name | upper }}_REPUBLISH_THREADPOOL_QUEUE_CAPACITY
  value: {{ .Values.polaris.republish.threadpool.queueCapacity | quote }}
- name: {{ .Values.image.name | upper }}_REPUBLISH_BATCH_SIZE
  value: {{ .Values.polaris.republish.batchSize | quote }}
- name: {{ .Values.image.name | upper }}_REPUBLISHING_TIMEOUT_MS
  value: {{ .Values.polaris.republish.timeoutMs | quote }}
- name: {{ .Values.common.product | upper}}_MONGO_CLIENTID
  value: {{ .Values.polaris.mongo.clientId | quote }}
- name: {{ .Values.common.product | upper}}_MONGO_URL
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-polaris-mongo
      key: mongoUrl
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
{{- end -}}
