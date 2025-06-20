<!--
Copyright 2024 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->
# Horizon-Comet Helm chart

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) 

Helm chart for deploying Horizon's [Comet](https://github.com/telekom/pubsub-horizon-comet) component.


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":8,"minReplicas":2,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler configuration. |
| comet.cache | object | `{"deDuplication":{"enabled":true},"serviceDNS":"app-cache-headless.integration.svc.cluster.local"}` | Cache configuration: Define cache service DNS and enable data deduplication. |
| comet.callback | object | `{"backoffMultiplier":2,"initialBackoffIntervalMs":100,"maxBackoffIntervalMs":60000,"maxConnections":1000,"maxRetries":10,"maxTimeout":30000,"redeliveryQueueCapacity":2048,"redeliveryStatusCodes":"401,429,502,503,504","redeliveryThreadpoolSize":16,"successfulStatusCodes":"200,201,202,204"}` | Callback configuration: Configures parameters for callback handling, including timeouts, retries, backoff intervals, connection limits, and status codes for success and redelivery. |
| comet.iris | object | `{"clientId":"clientId","clientSecret":"secret","tokenEndpoint":"irisUrl"}` | Iris configuration: Authentication details for Iris, including the token endpoint, clientId, and client secret. |
| comet.kafka | object | `{"consumerQueueCapacity":8192,"consumerThreadpoolSize":4096,"consumingGroupId":"comet","consumingPartitionCount":16,"maxPollRecords":500}` | Kafka configuration for "comet" component: Specifies Kafka details for the "comet" component, such as consumingGroupId, consumingPartitionCount, consumerThreadPoolSize, consumerQueueCapacity and maxPollRecords. |
| comet.security | object | `{"retrieveTokenConnectTimeout":5000,"retrieveTokenReadTimeout":5000}` | Security configuration: Set timeouts for secure token retrieval. |
| commonHorizon.defaultEnvironment | string | `"default"` | Sets the default environment. |
| commonHorizon.horizonLogLevel | string | `"WARN"` | Sets the log level for Horizon specific logging. |
| commonHorizon.informer | object | `{"namespace":"default"}` | Specifies namespace for the informer that watches the custom resources. |
| commonHorizon.issuerUrl | string | `"https://keycloak.example.domain.com/auth/realms/example"` | Sets the issuerUrl that is used for authentication. |
| commonHorizon.jmxRemote | object | `{"enabled":false}` | Enables or disables JMX remote configuration. |
| commonHorizon.kafka | object | `{"acks":1,"brokers":"kafka:9092","compression":{"enabled":true,"type":"snappy"},"groupId":"comet","lingerMs":5}` | Specifies Kafka broker details for common Horizon settings, including broker addresses, groupId, linger time, acknowledgment settings, and compression options. |
| commonHorizon.logLevel | string | `"WARN"` | Sets the log level for general logging. |
| commonHorizon.publishingTimeoutMs | int | `45000` | Sets the timeout duration (in milliseconds) for the publishing process. |
| commonHorizon.tracing | object | `{"debugEnabled":false,"jaegerCollectorBaseUrl":"http://localhost:14268","samplerProbability":"1.0"}` | Configures tracing settings, including debug mode, Jaeger collector base URL, and sampler probability. |
| customEnv | object | `{}` | Custom environment variables |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"example.devops.company.de/internal/example/horizon/develop","tag":"develop"}` | Specifies the image details such as repository, tag, and pull policy. |
| imagePullSecrets | list | `[]` | List of pull secrets that are required for pulling the the container images. |
| ingress | object | `{"annotations":{"kubernetes.io/ingress.class":"nginx","kubernetes.io/tls-acme":"true","nginx.ingress.kubernetes.io/backend-protocol":"HTTP","nginx.ingress.kubernetes.io/force-ssl-redirect":"true"},"className":"","enabled":true,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Specifies whether ingress is enabled, sets the hostname(s) and Ingress annotations. |
| lifecycle | string | `nil` |  |
| livenessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Liveness Probe configuration. |
| monitoring | object | `{"serviceMonitor":{"enabled":true,"selector":"selector","targetLabels":["ei.telekom.de/cluster","ei.telekom.de/namespace","ei.telekom.de/product","ei.telekom.de/team","ei.telekom.de/environment","app"]}}` | ServiceMonitor configuration. |
| nameOverride | string | `"comet"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | Specifies the annotationsfor the pod. |
| podLabels | object | `{}` | Specifies the labels for the pod. |
| podSecurityContext | object | `{"fsGroup":1000,"supplementalGroups":[1000]}` | Security context set for the pod. |
| readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Readiness Probe configuration. |
| replicaCount | int | `1` | Sets the number of replicas for the deployment. |
| resources | object | `{"limits":{"cpu":4,"memory":"4Gi"},"requests":{"cpu":"50m","memory":"200Mi"}}` | Resource limits and requests. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context set for the container. |
| service | object | `{"labels":{"ei.telekom.de/cluster":"AWS-Integration","ei.telekom.de/environment":"integration","ei.telekom.de/product":"horizon","ei.telekom.de/team":"pandora"},"port":"http","type":"ClusterIP"}` | Specifies the service type and port as well as the labels for the service. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | RBAC (Role-Based Access Control) specific configuration. |
| startupProbe | object | `{"failureThreshold":75,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":0,"periodSeconds":1}` | Kubernetes Startup Probe configuration. |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/tmp"` |  |
| volumeMounts[0].name | string | `"tmp"` |  |
| volumes[0].emptyDir | object | `{}` |  |
| volumes[0].name | string | `"tmp"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)