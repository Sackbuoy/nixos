# Nix Profiles

A collection of development environment tools managed with Nix flakes.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled

To enable flakes, add the following to your Nix configuration (`~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

```
experimental-features = nix-command flakes
```

## Available Profiles

| Profile    | Description                                      |
|------------|--------------------------------------------------|
| `work`     | Work development environment (Go, Kubernetes, Terraform, CLI tools, etc.) |
| `personal` | Personal development environment (Go, Python, Kubernetes, desktop apps, etc.) |

## Usage

### Installing a Profile

```bash
# Install the work profile
nix profile install .#work

# Install the personal profile
nix profile install .#personal

# Install the default profile (personal)
nix profile install .
```

### Updating a Profile

To update packages to their latest versions:

```bash
# Update the flake inputs
nix flake update

# Upgrade installed profiles
nix profile upgrade '.*'
```

### Removing a Profile

```bash
# List installed profiles to find the index
nix profile list

# Remove by index (e.g., index 0)
nix profile remove 0
```

### Testing Before Installing

You can try out packages without installing them:

```bash
# Enter a shell with the work profile
nix develop .#work

# Or run a one-off command
nix shell .#work -c <command>
```

## Project Structure

```
.
├── flake.nix          # Main flake definition
├── flake.lock         # Locked dependencies
├── packages/          # Package category definitions
│   ├── default.nix    # Package aggregator
│   ├── cli.nix        # CLI tools
│   ├── desktop.nix    # Desktop applications
│   ├── go.nix         # Go development tools
│   ├── kubernetes.nix # Kubernetes tools
│   ├── nix.nix        # Nix utilities
│   ├── python.nix     # Python development tools
│   ├── terraform.nix  # Terraform/IaC tools
│   ├── web.nix        # Web development tools
│   ├── workflow.nix   # Workflow/productivity tools
│   └── other.nix      # Miscellaneous packages
└── profiles/          # Profile definitions
    ├── default.nix    # Profile aggregator
    ├── work.nix       # Work profile composition
    └── personal.nix   # Personal profile composition
```

## Customization

### Adding New Packages

1. Add the package to the appropriate category file in `packages/`
2. The package will automatically be included in profiles that use that category

### Creating a New Profile

1. Create a new file in `profiles/` (e.g., `profiles/minimal.nix`)
2. Import the desired package categories:
   ```nix
   {packages}:
   with packages;
     cli
     ++ nix
   ```
3. Add the profile to `profiles/default.nix`
4. Add a new output in `flake.nix`

## Supported Systems

- `aarch64-darwin` (Apple Silicon macOS)
- `x86_64-linux` (Linux x86_64)
