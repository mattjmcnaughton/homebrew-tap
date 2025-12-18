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

### Step 5: Validate

After creating or updating the formula file, ensure it has proper read permissions:

```bash
chmod a+r Formula/{formula-name}.rb
```

Run Homebrew style check:

```bash
brew style Formula/{formula-name}.rb
```

This validates the formula against Homebrew's Ruby style guidelines.

### Step 6: Test Installation (Optional)

Suggest the user test locally:

```bash
brew install --build-from-source Formula/{formula-name}.rb
```
