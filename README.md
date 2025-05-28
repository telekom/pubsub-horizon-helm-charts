<!--
Copyright 2024 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->

# Horizon Helm Charts

This repository contains all the Helm charts required to roll out Horizon. Please refer to [documentation of the entire system](https://github.com/telekom/pubsub-horizon) to get the full picture.

## Contents

Please visit the corresponding README of the respective Helm chart for more information.

* [horizon-comet](./charts/horizon-comet/README.md)
* [horizon-galaxy](./charts/horizon-galaxy/README.md)
* [horizon-polaris](./charts/horizon-polaris/README.md)
* [horizon-pulsar](./charts/horizon-pulsar/README.md)
* [horizon-starlight](./charts/horizon-starlight/README.md)
* [horizon-vortex](./charts/horizon-vortex/README.md)

## Install Chart

If you want to install a Helm Chart of a component, execute this command:

```shell
helm install -f <valuesfile> -n <namespace> [RELEASE_NAME] oci://ghcr.io/telekom/o28m-charts/<chartname> --version <chartversion> 
```
*Replace `<chartname>` with the name of the Horizon component/Helm chart name, that you wish to install. For example: `horizon-starlight`. Also make sure to replace `<namespace>` with the correct target namespace on the cluster and provide a valid helm chart version, e.g. `1.0.0`.* 

We also added a parent Helm chart `horizon-all` that can be used to install all Horizon components at once. The corresponding command would look something like this:

```shell
helm install -f my-values.yaml -n platform horizon oci://ghcr.io/telekom/o28m-charts/horizon-all
```

> **Note:** Horizon is a complex software that consists of many different interdependent components. Operating components individually is not conducive to a functional Horizon installation.
We therefore strongly advise you to follow our [installation guide](https://github.com/telekom/pubsub-horizon/blob/main/docs/installation.md).

## Contributing

We're committed to open source, so we welcome and encourage everyone to join its developer community and contribute, whether it's through code or feedback.  
By participating in this project, you agree to abide by its [Code of Conduct](./CODE_OF_CONDUCT.md) at all times.


## Code of Conduct

This project has adopted the [Contributor Covenant](https://www.contributor-covenant.org/) in version 2.1 as our code of conduct. Please see the details in our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). All contributors must abide by the code of conduct.

## Licensing

This project follows the [REUSE standard for software licensing](https://reuse.software/). You can find a guide for developers at https://telekom.github.io/reuse-template/.   
Each file contains copyright and license information, and license texts can be found in the [./LICENSES](./LICENSES) folder. For more information visit https://reuse.software/.
