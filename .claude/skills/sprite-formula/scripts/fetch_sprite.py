#!/usr/bin/env python3
"""Fetch Sprite CLI version and checksums for Homebrew formula updates."""

import json
from typing import Optional

import httpx
import typer

BASE_URL = "https://sprites-binaries.t3.storage.dev"
PLATFORMS = [
    ("darwin", "arm64"),
    ("darwin", "amd64"),
    ("linux", "arm64"),
    ("linux", "amd64"),
]

app = typer.Typer(help="Fetch Sprite CLI release info for Homebrew formula updates")


def fetch_version(channel: str) -> str:
    """Fetch version from channel file."""
    url = f"{BASE_URL}/client/{channel}.txt"
    response = httpx.get(url, follow_redirects=True)

    if response.status_code == 404 and channel == "release":
        # Fall back to RC channel if no release exists
        typer.echo("No release found, falling back to RC channel...", err=True)
        return fetch_version("rc")

    response.raise_for_status()
    return response.text.strip()


def fetch_checksum(version: str, platform: str, arch: str) -> str:
    """Fetch SHA256 checksum for a specific platform/arch."""
    url = f"{BASE_URL}/client/{version}/sprite-{platform}-{arch}.tar.gz.sha256"
    response = httpx.get(url, follow_redirects=True)
    response.raise_for_status()

    # Checksum file may contain just the hash or "hash  filename"
    content = response.text.strip()
    return content.split()[0]


@app.command()
def main(
    channel: str = typer.Option(
        "release",
        "--channel",
        "-c",
        help="Release channel: release, rc, or dev",
    ),
    version: Optional[str] = typer.Option(
        None,
        "--version",
        "-v",
        help="Specific version to fetch (e.g., v1.2.3). Overrides channel.",
    ),
    output_json: bool = typer.Option(
        False,
        "--json",
        "-j",
        help="Output as JSON",
    ),
) -> None:
    """Fetch Sprite CLI version and checksums."""
    try:
        # Determine version
        if version:
            ver = version if version.startswith("v") else f"v{version}"
        else:
            ver = fetch_version(channel)

        # Fetch checksums for all platforms
        checksums = {}
        for platform, arch in PLATFORMS:
            key = f"{platform}-{arch}"
            checksums[key] = fetch_checksum(ver, platform, arch)

        # Output results
        if output_json:
            result = {
                "version": ver,
                "version_no_prefix": ver.lstrip("v"),
                "checksums": checksums,
            }
            typer.echo(json.dumps(result, indent=2))
        else:
            typer.echo(f"Version: {ver}")
            typer.echo(f"Version (no prefix): {ver.lstrip('v')}")
            typer.echo("")
            typer.echo("Checksums:")
            for key, checksum in checksums.items():
                typer.echo(f"  {key}: {checksum}")
            typer.echo("")
            typer.echo("Formula updates needed:")
            typer.echo(f'  version "{ver.lstrip("v")}"')
            for key, checksum in checksums.items():
                typer.echo(f'  # {key}')
                typer.echo(f'  sha256 "{checksum}"')

    except httpx.HTTPStatusError as e:
        typer.echo(f"HTTP error: {e.response.status_code} for {e.request.url}", err=True)
        raise typer.Exit(1)
    except httpx.RequestError as e:
        typer.echo(f"Request error: {e}", err=True)
        raise typer.Exit(1)


if __name__ == "__main__":
    app()
