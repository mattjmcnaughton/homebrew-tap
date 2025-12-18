#!/usr/bin/env python3
"""Fetch GitHub release assets and compute SHA256 checksums for Homebrew formulas."""

import asyncio
import hashlib
import json
import sys

import httpx
import typer


app = typer.Typer(help="Fetch GitHub release assets and compute SHA256 checksums")

# Supported archive formats
SUPPORTED_EXTENSIONS = (".tar.gz", ".tgz", ".tar.xz", ".tar.bz2", ".zip")


def is_supported_archive(name: str) -> bool:
    """Check if asset name has a supported archive extension."""
    return any(name.endswith(ext) for ext in SUPPORTED_EXTENSIONS)


async def fetch_release_info(client: httpx.AsyncClient, owner: str, repo: str, version: str) -> dict:
    """Fetch release information from GitHub API.

    Tries both v-prefixed and non-prefixed tag formats.
    """
    # Build list of tags to try (v-prefixed first as it's most common)
    if version.startswith("v"):
        tags_to_try = [version, version.lstrip("v")]
    else:
        tags_to_try = [f"v{version}", version]

    for tag in tags_to_try:
        url = f"https://api.github.com/repos/{owner}/{repo}/releases/tags/{tag}"
        response = await client.get(url)

        if response.status_code == 200:
            typer.echo(f"Found release with tag: {tag}", err=True)
            return response.json()
        elif response.status_code != 404:
            typer.echo(f"Error: HTTP {response.status_code} fetching release info", err=True)
            raise typer.Exit(1)

    # Neither tag format worked
    tried_tags = " or ".join(tags_to_try)
    typer.echo(f"Error: Release not found for {owner}/{repo} (tried tags: {tried_tags})", err=True)
    raise typer.Exit(1)


async def compute_sha256(client: httpx.AsyncClient, url: str, name: str) -> str:
    """Download asset and compute SHA256 checksum."""
    typer.echo(f"Computing SHA256 for {name}...", err=True)

    async with client.stream("GET", url, follow_redirects=True) as response:
        if response.status_code != 200:
            typer.echo(f"Error: Failed to download {url}: HTTP {response.status_code}", err=True)
            raise typer.Exit(1)

        sha256 = hashlib.sha256()
        async for chunk in response.aiter_bytes(chunk_size=8192):
            sha256.update(chunk)

    return sha256.hexdigest()


async def process_asset(client: httpx.AsyncClient, asset: dict) -> dict:
    """Process a single asset: download and compute checksum."""
    name = asset["name"]
    url = asset["browser_download_url"]

    sha256 = await compute_sha256(client, url, name)

    platform = "unknown"
    arch = "unknown"
    if "macos" in name.lower() or "darwin" in name.lower():
        platform = "macos"
    elif "linux" in name.lower():
        platform = "linux"

    if "aarch64" in name.lower() or "arm64" in name.lower():
        arch = "arm"
    elif "x86_64" in name.lower() or "amd64" in name.lower():
        arch = "intel"

    return {
        "name": name,
        "url": url,
        "sha256": sha256,
        "platform": platform,
        "arch": arch,
    }


async def main_async(repo: str, version: str, json_output: bool) -> None:
    """Main async function."""
    if "/" not in repo:
        typer.echo("Error: Repository must be in owner/repo format", err=True)
        raise typer.Exit(1)

    owner, repo_name = repo.split("/", 1)

    headers = {
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "homebrew-formula-skill",
    }

    async with httpx.AsyncClient(headers=headers, timeout=120.0) as client:
        typer.echo(f"Fetching release {version} for {owner}/{repo_name}...", err=True)
        release_info = await fetch_release_info(client, owner, repo_name, version)

        assets = release_info.get("assets", [])
        archive_assets = [a for a in assets if is_supported_archive(a["name"])]

        if not archive_assets:
            typer.echo(
                f"Error: No supported archive assets found in release.\n"
                f"Supported formats: {', '.join(SUPPORTED_EXTENSIONS)}\n"
                f"Note: Vanilla (uncompressed) binaries are not currently supported.",
                err=True,
            )
            raise typer.Exit(1)

        typer.echo(f"Found {len(archive_assets)} supported archive(s)", err=True)

        # Process all assets concurrently
        tasks = [process_asset(client, asset) for asset in archive_assets]
        asset_results = await asyncio.gather(*tasks)

    results = {
        "version": version,
        "repo": f"{owner}/{repo_name}",
        "assets": asset_results,
    }

    if json_output:
        typer.echo(json.dumps(results, indent=2))
    else:
        for asset in asset_results:
            typer.echo(f"\n{asset['name']}")
            typer.echo(f"  URL: {asset['url']}")
            typer.echo(f"  SHA256: {asset['sha256']}")
            typer.echo(f"  Platform: {asset['platform']}, Arch: {asset['arch']}")
        typer.echo(f"\nFound {len(asset_results)} assets", err=True)


@app.command()
def main(
    repo: str = typer.Argument(..., help="GitHub repository (owner/repo format)"),
    version: str = typer.Argument(..., help="Release version (e.g., 1.3.0 or v1.3.0)"),
    json_output: bool = typer.Option(False, "--json", help="Output in JSON format"),
) -> None:
    """Fetch GitHub release assets and compute SHA256 checksums."""
    asyncio.run(main_async(repo, version, json_output))


if __name__ == "__main__":
    app()
