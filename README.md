# Homebrew Tools Tap

Custom Homebrew tap for utilities maintained by [@mattjmcnaughton](https://github.com/mattjmcnaughton). Add the tap and install formulas directly from this repository.

## Usage

```bash
brew tap mattjmcnaughton/tap
brew install mattjmcnaughton/tap/context7-cli
```

Update with Homebrew’s standard workflow:

```bash
brew update
brew upgrade context7-cli
```

## Available Formulas

- `context7-cli` — CLI helper around Context7 AI workflows. Project source: https://github.com/mattjmcnaughton/context7-cli
- `ds-store-no-more` — CLI for cleaning up .DS_Store files and other unwanted filesystem clutter. Project source: https://github.com/mattjmcnaughton/ds-store-no-more
- `fetch-context` — Pull external context (repos, web pages) into the current repo for agents. Project source: https://github.com/mattjmcnaughton/fetch-context
- `file-lock` — Encrypt declared sensitive files to protect them from coding agents. Project source: https://github.com/mattjmcnaughton/file-lock
- `grov` — Service orchestrator for local development with per-worktree isolation. Project source: https://github.com/mattjmcnaughton/grov
- `rasm-tui` — Terminal UI for managing AWS Secrets Manager with Vim-style navigation. Project source: https://github.com/mattjmcnaughton/rasm-tui
- `rtree` — Fast, deterministic directory tree visualization tool written in Rust. Project source: https://github.com/mattjmcnaughton/rtree
- `skillvendor` — Vendor remote skills from git repositories into local skill directories. Project source: https://github.com/mattjmcnaughton/skillvendor
- `sprite` — CLI for managing Sprites. Project source: https://sprites.dev

## Development

Formula definitions live in `Formula/`.

### Using Claude Code

This repository includes a Claude Code skill that automates formula creation and updates. With Claude Code running in this directory, simply ask:

- "Create a new formula for `owner/repo` at version `x.y.z`"
- "Update `formula-name` to version `x.y.z`"

Claude Code will automatically:
1. Fetch release assets from GitHub
2. Compute SHA256 checksums for each platform
3. Infer description and license from the repository
4. Generate or update the formula file
5. Run style validation

### Manual workflow

When publishing a new release manually:

1. Update the formula version, URLs, and SHA256 checksums.
2. Run `brew style Formula/<formula>.rb` to validate.
3. Install from the tap to verify: `brew install mattjmcnaughton/tap/<formula>`.
4. Commit changes and push to `main`.

### Fetching release checksums

Use a version environment variable so the commands stay reusable:

```bash
export CONTEXT7_CLI_VERSION="v1.3.0"
curl -sL "https://api.github.com/repos/mattjmcnaughton/context7-cli/releases/tags/${CONTEXT7_CLI_VERSION}"
curl -sL "https://api.github.com/repos/mattjmcnaughton/context7-cli/releases/tags/${CONTEXT7_CLI_VERSION}" \
  | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | "\(.name) \(.browser_download_url) \(.digest)"'
```

### Updating the sprite formula

The sprite formula downloads binaries from a custom CDN rather than GitHub releases.

1. Fetch the current release version:
   ```bash
   curl -s https://sprites-binaries.t3.storage.dev/client/release.txt
   # Falls back to RC if no release: curl -s https://sprites-binaries.t3.storage.dev/client/rc.txt
   ```

2. Fetch checksums for all platforms:
   ```bash
   export SPRITE_VERSION="v0.0.1-rc29"  # from step 1

   for asset in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
     echo "$asset: $(curl -s "https://sprites-binaries.t3.storage.dev/client/${SPRITE_VERSION}/sprite-${asset}.tar.gz.sha256")"
   done
   ```

3. Update `Formula/sprite.rb` with the new version (without the `v` prefix) and checksums.

4. Validate and test:
   ```bash
   brew style Formula/sprite.rb
   brew install --build-from-source mattjmcnaughton/tap/sprite
   ```

### Local Homebrew tap testing

Homebrew expects formulae to live inside a tap. To run `brew install`, `brew audit`, or `brew style` on a formula you're developing locally, you must first tap your local clone.

#### Tap your local clone

```bash
brew tap mattjmcnaughton/tap-local /Users/mattjmcnaughton/code/sandbox/homebrew-tap
```

After tapping, Homebrew treats that directory as the canonical source for the tap.

#### Commit changes before running checks

Some Homebrew workflows (especially CI-like flows such as `brew test-bot`) assume the tap is in a clean, committed state. Homebrew may read tap metadata from Git, infer versions/revisions, or run checks in a sandbox that expects a known commit.

**Uncommitted changes can cause:**
- Edits not being picked up as expected
- "Dirty working tree" warnings/errors
- Differences between local tests and CI behavior

**Recommended practice** — commit before running audit/style/install/test:

```bash
git add Formula/sprite.rb
git commit -m "WIP: update sprite formula"
```

If you don't want to pollute history, use `git commit --amend --no-edit` to keep a single rolling commit, or work on a local-only branch.

#### Run validation commands

Use the tap-qualified formula name:

```bash
brew install  mattjmcnaughton/tap-local/sprite
brew audit    --strict mattjmcnaughton/tap-local/sprite
brew style    mattjmcnaughton/tap-local/sprite
brew test     mattjmcnaughton/tap-local/sprite
```

Or (once tapped) the short name often works:

```bash
brew install sprite
brew audit --strict sprite
brew style sprite
brew test sprite
```

#### Iteration loop

Typical edit → test cycle:

```bash
# Edit Formula/sprite.rb

git add Formula/sprite.rb
git commit -m "WIP: tweak sprite formula"

brew reinstall --build-from-source mattjmcnaughton/tap-local/sprite --verbose
brew test   mattjmcnaughton/tap-local/sprite
brew audit  --strict mattjmcnaughton/tap-local/sprite
brew style  mattjmcnaughton/tap-local/sprite
```

#### Untap when done

To unregister the tap from Homebrew (does not delete your local repo):

```bash
brew untap mattjmcnaughton/tap-local
```

#### Retap after moving the repo

If you moved the directory or want to reset the path:

```bash
brew untap mattjmcnaughton/tap-local
brew tap   mattjmcnaughton/tap-local /new/absolute/path/to/homebrew-tap
```

#### Verification commands

```bash
brew tap                                          # List installed taps
brew info mattjmcnaughton/tap-local/sprite        # Confirm formula is loaded
brew info --debug mattjmcnaughton/tap-local/sprite # Extra diagnostics
```
