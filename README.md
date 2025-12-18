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
