# License CLI

[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25.svg)](https://www.gnu.org/software/bash/)

A lightweight Bash command line utility for managing and applying software license templates. This tool allows users to quickly list available licenses, sync them from a remote repository, and apply a specific license to the current project directory.

## Features

- **Quick Application**: Apply license templates (e.g., MIT, GPL-2.0) directly to your project as a `LICENSE` file.
- **Local Caching**: Stores license templates locally for offline use after the initial sync.
- **XDG Compliant**: Follows XDG Base Directory Specification for binary and data storage.
- **Integrity Validation**: Includes a validation script to ensure consistency between license metadata and templates.
- **Zero Dependencies**: Requires only Bash and `curl`.

## Tech Stack

- **Shell**: Bash
- **Network**: Curl

## Project Structure

- `licenses`: The main entry point script that routes commands.
- `licenses-list`: Subcommand for listing available licenses in the local cache.
- `licenses-get`: Subcommand for retrieving a specific license and creating a `LICENSE` file.
- `licenses-update`: Subcommand for syncing license templates from the upstream repository.
- `install.sh`: Automated installation script for local setup.
- `validate.sh`: Integrity check utility for license files and metadata.
- `license-templates/`: Directory containing the text for various license types.
- `metadata/`: Contains the index for license discovery.

## Installation

You can install the utility using the provided installation script:

```bash
curl -sSL https://raw.githubusercontent.com/unamatasanatarai/licenses/master/install.sh | bash
```

Alternatively, run the script locally from the repository:

```bash
./install.sh
```

Ensure that your `PATH` includes the installation directory (usually `~/.local/bin`).

## Usage

### Sync Licenses
Download or update the local cache with the latest license templates:
```bash
licenses update
```

### List Available Licenses
View all licenses currently available in your local cache:
```bash
licenses list
```

### Apply a License
Create a `LICENSE` file in the current directory (e.g., for MIT):
```bash
licenses get MIT
```

## Validation

The project includes a validation script to ensure that all indexed licenses have corresponding template files and follow naming conventions:

```bash
./validate.sh
```

## License

This project is licensed under the GNU General Public License v2.0. See the [LICENSE](LICENSE) file for details.
