---
name: sprite-formula
description: Update the Sprite CLI Homebrew formula to a new version. This skill should be used when users want to update the sprite formula to the latest release or a specific version.
---

# Sprite Formula Update

This skill updates the `sprite` Homebrew formula in `Formula/sprite.rb`.

The sprite formula is different from other formulas in this tap because it downloads binaries from a custom CDN (`sprites-binaries.t3.storage.dev`) rather than GitHub releases.

## Workflow

### Step 1: Determine Version

Ask the user which version to update to:
- **Latest release**: Fetch from `release.txt` channel file
- **Latest RC**: Fetch from `rc.txt` channel file
- **Specific version**: User provides version tag (e.g., `v1.2.3`)

### Step 2: Fetch Version and Checksums

Run the fetch script to get the version and all platform checksums:

```bash
uv run --with httpx,typer python .claude/skills/sprite-formula/scripts/fetch_sprite.py
```

Options:
- `--channel release` (default) - fetch latest release version
- `--channel rc` - fetch latest release candidate
- `--version v1.2.3` - fetch a specific version
- `--json` - output as JSON for programmatic use

The script fetches:
- Version string from channel file (or uses provided version)
- SHA256 checksums for all 4 platform/arch combinations:
  - darwin-arm64
  - darwin-amd64
  - linux-arm64
  - linux-amd64

### Step 3: Update Formula

Update `Formula/sprite.rb` with:
1. New version number (without `v` prefix)
2. All four SHA256 checksums

The URL pattern uses string interpolation, so only the version and checksums need updating:
```ruby
version "1.2.3"  # no 'v' prefix
# URLs automatically use v#{version}
```

### Step 4: Validate and Test Locally

1. **Commit changes before running Homebrew checks:**

Homebrew workflows may read tap metadata from Git and expect a clean, committed state. Uncommitted changes can cause edits to not be picked up, "dirty working tree" errors, or differences between local and CI behavior.

```bash
git add Formula/sprite.rb
git commit -m "WIP: update sprite formula"
```

Use `git commit --amend --no-edit` for rapid iteration without creating many commits.

2. **Ensure the local tap is registered:**

```bash
brew tap mattjmcnaughton/tap-local /Users/mattjmcnaughton/code/sandbox/homebrew-tap
```

3. **Run validation commands:**

```bash
brew style  mattjmcnaughton/tap-local/sprite
brew audit  --strict mattjmcnaughton/tap-local/sprite
```

4. **Test installation:**

```bash
brew reinstall --build-from-source mattjmcnaughton/tap-local/sprite --verbose
brew test mattjmcnaughton/tap-local/sprite
sprite --help
```

#### Iteration loop

For rapid development:

```bash
# Edit Formula/sprite.rb
git add Formula/sprite.rb
git commit --amend --no-edit

brew reinstall --build-from-source mattjmcnaughton/tap-local/sprite --verbose
brew test   mattjmcnaughton/tap-local/sprite
brew audit  --strict mattjmcnaughton/tap-local/sprite
brew style  mattjmcnaughton/tap-local/sprite
```

#### Cleanup

When done testing:

```bash
brew untap mattjmcnaughton/tap-local
```

## CDN Structure

Base URL: `https://sprites-binaries.t3.storage.dev`

Channel files:
- `/client/release.txt` - stable release version
- `/client/rc.txt` - release candidate version

Binary assets:
- `/client/{version}/sprite-{platform}-{arch}.tar.gz`
- `/client/{version}/sprite-{platform}-{arch}.tar.gz.sha256`

Where:
- `{version}` includes the `v` prefix (e.g., `v1.2.3`)
- `{platform}` is `darwin` or `linux`
- `{arch}` is `arm64` or `amd64`
