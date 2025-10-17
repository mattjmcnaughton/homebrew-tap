# Homebrew Tools Tap

Custom Homebrew tap for utilities maintained by [@mattjmcnaughton](https://github.com/mattjmcnaughton). Add the tap and install formulas directly from this repository.

## Usage

```bash
brew tap mattjmcnaughton/tools
brew install mattjmcnaughton/tools/context7-cli
```

Update with Homebrew’s standard workflow:

```bash
brew update
brew upgrade context7-cli
```

## Available Formulas

- `context7-cli` — CLI helper around Context7 AI workflows. Project source: https://github.com/mattjmcnaughton/context7-cli

## Development

Formula definitions live in `Formula/`. When publishing a new release:

1. Update the formula version, URLs, and SHA256 checksums.
2. Run `brew audit --strict --new-formula Formula/<formula>.rb`.
3. Install from the tap to verify: `brew install mattjmcnaughton/tools/<formula>`.
4. Commit changes and push to `main`.

### Fetching release checksums

Use a version environment variable so the commands stay reusable:

```bash
export CONTEXT7_CLI_VERSION="v1.3.0"
curl -sL "https://api.github.com/repos/mattjmcnaughton/context7-cli/releases/tags/${CONTEXT7_CLI_VERSION}"
curl -sL "https://api.github.com/repos/mattjmcnaughton/context7-cli/releases/tags/${CONTEXT7_CLI_VERSION}" \
  | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | "\(.name) \(.browser_download_url) \(.digest)"'
```
