# 1.0.0 (2025-06-18)


### Bug Fixes

* changed resource and label names to avoid conflicts when using parent chart ([dfb0b56](https://github.com/telekom/pubsub-horizon-helm-charts/commit/dfb0b5659cc164726396ba1a66d46750bd1dd9fb))
* do not fail for packaging horizon-all helm chart ([c74d966](https://github.com/telekom/pubsub-horizon-helm-charts/commit/c74d96689dde2f99ef88ef7200f1b6a98d584bae))
* fixed name conflicts for rbac resources when using parent chart ([526373f](https://github.com/telekom/pubsub-horizon-helm-charts/commit/526373faaa75186f78d1acbe0d52c14b389f023d))
* reuse compliance ([f9b589a](https://github.com/telekom/pubsub-horizon-helm-charts/commit/f9b589ac0813b287b8a7b81d9433008b4437a954))


### Features

* added horizon parent chart for installing all components at once ([619d909](https://github.com/telekom/pubsub-horizon-helm-charts/commit/619d909418311395ef624c3fbfb1e2f63a1a849b))
* re-add polaris to horizon-all dependency ([ee30934](https://github.com/telekom/pubsub-horizon-helm-charts/commit/ee3093432b999512ba9e59c1948755e7469ec41c))
* re-added polaris and horizon-all helm chart ([c7ea623](https://github.com/telekom/pubsub-horizon-helm-charts/commit/c7ea6235f57853eabce627e05f9c3fb0c931401e))
* Support graceful shutdown with possible delayed pod termination in k8s ([9f6264d](https://github.com/telekom/pubsub-horizon-helm-charts/commit/9f6264d81cdceb88f7b97acd8df6db3b5f6b7de2))
