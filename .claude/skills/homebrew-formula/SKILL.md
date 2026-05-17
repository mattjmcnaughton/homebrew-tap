---
name: homebrew-formula
description: Create or update Homebrew formulas in this tap. This skill should be used when users want to add a new formula or update an existing formula's version, URLs, or checksums.
---

# Homebrew Formula Management

This skill creates and updates Homebrew formulas in the `Formula/` directory of this tap.

## Workflow

### Step 1: Determine Action

Ask the user whether to create a new formula or update an existing one.

### Step 2: Gather Information

For a **new formula**, collect:
- Formula name (kebab-case, e.g., `context7-cli`)
- GitHub repository (owner/repo format)
- Version to release

When the GitHub repository is provided, automatically fetch the README and LICENSE files to infer:
- Short description (from README)
- License type (from LICENSE file)

The binary name pattern typically matches the formula name (e.g., `{formula-name}-*`).

For an **update**, collect:
- Which formula to update (check `Formula/` directory)
- New version number

### Step 3: Fetch Release Assets and Checksums

Run the `fetch_release.py` script using `uv run` to get release asset URLs and SHA256 checksums:

```bash
uv run --with httpx,typer python .claude/skills/homebrew-formula/scripts/fetch_release.py owner/repo version
```

Example:
```bash
uv run --with httpx,typer python .claude/skills/homebrew-formula/scripts/fetch_release.py mattjmcnaughton/context7-cli 1.3.0
```

The script outputs:
- Asset URLs for each platform (macos-aarch64, macos-x86_64, linux-x86_64)
- SHA256 checksums computed by downloading each tarball
- Platform and architecture detection

Use `--json` flag for machine-readable output.

### Step 4: Create or Update Formula

Formula location: `Formula/{formula-name}.rb`

Reference the existing formula at `Formula/context7-cli.rb` for the expected structure.

#### Formula Template

```ruby
class FormulaClassName < Formula
  desc "Short description"
  homepage "https://github.com/{owner}/{repo}"
  version "{version}"
  license "{license}"

  on_macos do
    on_arm do
      url "https://github.com/{owner}/{repo}/releases/download/v{version}/{name}-macos-aarch64.tar.gz"
      sha256 "{sha256_macos_arm}"
    end

    on_intel do
      url "https://github.com/{owner}/{repo}/releases/download/v{version}/{name}-macos-x86_64.tar.gz"
      sha256 "{sha256_macos_intel}"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/{owner}/{repo}/releases/download/v{version}/{name}-linux-x86_64.tar.gz"
      sha256 "{sha256_linux_intel}"
    end
  end

  def install
    binary = Dir["{binary-pattern}"]&.first
    raise "{binary-name} binary not found in archive" if binary.nil?

    bin.install binary => "{binary-name}"
  end

  test do
    output = shell_output("#{bin}/{binary-name} --help")
    assert_match "{expected-substring}", output
  end
end
```

#### Naming Conventions

- Class name: CamelCase version of formula name (`context7-cli` -> `Context7Cli`)
- Version field: No `v` prefix (`1.3.0` not `v1.3.0`)
- URL paths: Include `v` prefix (`v1.3.0`)

### Step 5: Validate and Test Locally

After creating or updating the formula file:

1. **Ensure proper read permissions:**

```bash
chmod a+r Formula/{formula-name}.rb
```

2. **Commit changes before running Homebrew checks:**

Homebrew workflows may read tap metadata from Git and expect a clean, committed state. Uncommitted changes can cause edits to not be picked up, "dirty working tree" errors, or differences between local and CI behavior.

```bash
git add Formula/{formula-name}.rb
git commit -m "WIP: update {formula-name} formula"
```

Use `git commit --amend --no-edit` for rapid iteration without creating many commits.

3. **Ensure the local tap is registered:**

Homebrew requires formulae to live inside a tap. Register the local clone:

```bash
brew tap mattjmcnaughton/tap-local /Users/mattjmcnaughton/code/sandbox/homebrew-tap
```

4. **Run validation commands using the tap-qualified name:**

```bash
brew style  mattjmcnaughton/tap-local/{formula-name}
brew audit  --strict mattjmcnaughton/tap-local/{formula-name}
```

5. **Test installation:**

```bash
brew reinstall --build-from-source mattjmcnaughton/tap-local/{formula-name} --verbose
brew test mattjmcnaughton/tap-local/{formula-name}
```

#### Iteration loop

For rapid development:

```bash
# Edit Formula/{formula-name}.rb
git add Formula/{formula-name}.rb
git commit --amend --no-edit

brew reinstall --build-from-source mattjmcnaughton/tap-local/{formula-name} --verbose
brew test   mattjmcnaughton/tap-local/{formula-name}
brew audit  --strict mattjmcnaughton/tap-local/{formula-name}
brew style  mattjmcnaughton/tap-local/{formula-name}
```

#### Verification commands

```bash
brew tap                                              # List installed taps
brew info mattjmcnaughton/tap-local/{formula-name}    # Confirm formula is loaded
```

#### Cleanup

When done testing, uninstall any formulae installed from the local tap before unregistering it (Homebrew refuses to untap while installed formulae remain):

```bash
brew uninstall {formula-name}
brew untap mattjmcnaughton/tap-local
```
