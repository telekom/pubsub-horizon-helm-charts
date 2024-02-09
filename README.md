<!--
Copyright 2024 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->

# Horizon Helm Charts

This repository contains all the Helm charts required to roll out Horizon.   

## Install Chart

If you want to install a Helm Chart of a component, execute this command

```shell
helm install [RELEASE_NAME] .\horizon-component -n default
```

## Contents

Please visit the corresponding README of the respective helmet chart for more information.

* [horizon-comet](./horizon-comet/README.md)
* [horizon-galaxy](./horizon-galaxy/README.md)
* [horizon-polaris](./horizon-polaris/README.md)
* [horizon-pulsar](./horizon-pulsar/README.md)
* [horizon-starlight](./horizon-starlight/README.md)
* [horizon-vortex](./horizon-vortex/README.md)

## Code of Conduct

This project has adopted the [Contributor Covenant](https://www.contributor-covenant.org/) in version 2.1 as our code of conduct. Please see the details in our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). All contributors must abide by the code of conduct.

By participating in this project, you agree to abide by its [Code of Conduct](./CODE_OF_CONDUCT.md) at all times.

## Licensing

This project follows the [REUSE standard for software licensing](https://reuse.software/).
Each file contains copyright and license information, and license texts can be found in the [./LICENSES](./LICENSES) folder. For more information visit https://reuse.software/.

### REUSE

For a comprehensive guide on how to use REUSE for licensing in this repository, visit https://telekom.github.io/reuse-template/.   
A brief summary follows below:

The [reuse tool](https://github.com/fsfe/reuse-tool) can be used to verify and establish compliance when new files are added. 

For more information on the reuse tool visit https://github.com/fsfe/reuse-tool.
