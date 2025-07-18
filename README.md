# OpenVox Workshop

This project is intended to be an OpenVox Module repository as an Open Source alternative to Puppet Forge.

> [!NOTE]
> This project is in pre-alpha and is not considered to be production ready.

## Overview

OpenVox Workshop is a self-hosted module repository that provides a platform for managing and distributing Puppet modules.
It aims to offer an open-source alternative to Puppet Forge with full API compatibility.

## Project Goals

High-level goals for this project.

- Web UI for searching for modules and managing modules
- Compatability with [Puppet Forge V3 API](https://forgeapi.puppet.com)

Issue tracking is done using [GitHub Issues](https://github.com/zaben903/OpenVox-Workshop/issues)

## Prerequisites

- Ruby 3.4
- PostgreSQL 17.x

## Development

To get started with a development environment, run the following commands:
```bash
# Clone the repository
git clone https://github.com/zaben903/OpenVox-Workshop.git
cd OpenVox-Workshop

# Setup dependencies and run the development environment.
./bin/setup
```

## Support
- [Issue Tracker](https://github.com/zaben903/OpenVox-Workshop/issues)
- [Discussions](https://github.com/zaben903/OpenVox-Workshop/discussions)

## Licence

[AGPL 3.0 or later](LICENSE)

## Acknowledgments
- Special thanks to the Vox Pupuli community for all their work in keeping Puppet open through OpenVox.
