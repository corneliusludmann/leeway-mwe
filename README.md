# Leeway Minimal Working Example (MWE)

A minimal working example demonstrating how to build Go and TypeScript projects with [Leeway](https://github.com/gitpod-io/leeway), a heavily caching build system.

## Project Structure

```
/
├── WORKSPACE.yaml           # Leeway workspace configuration
├── install-leeway.sh        # Script to install Leeway
└── components/              # Components directory
    ├── BUILD.yaml           # Meta-package to build all components
    ├── go-hello-world/      # Go project
    │   └── BUILD.yaml       # Go project build configuration
    └── ts-hello-world/      # TypeScript project
        └── BUILD.yaml       # TypeScript project build configuration
```

## Building with Leeway

### Prerequisites

- Go 1.20 or later
- Node.js and npm (for TypeScript project)
- Leeway (see installation instructions below)

### Installing Leeway

You can install Leeway using the provided installation script:

```bash
# Install from the main branch
./install-leeway.sh

# Or install a specific version or branch
./install-leeway.sh v0.2.0
./install-leeway.sh dev/my-new-feature
```

The script will:
1. Clone the Leeway repository into a temporary directory
2. Build Leeway from source
3. Install it to /usr/local/bin
4. Set up environment variables in ~/.leeway.env

After installation, you should source the environment variables:

```bash
source ~/.leeway.env
```

### Building Projects

Set the workspace root environment variable to the path where you cloned this repository:

```bash
export LEEWAY_WORKSPACE_ROOT=$(pwd)
```

Build all projects:

```bash
leeway build
```

Build specific projects:

```bash
# Build only the Go project
leeway build components/go-hello-world:app

# Build only the TypeScript project
leeway build components/ts-hello-world:app
```

## License

See the [LICENSE](LICENSE) file for details.
