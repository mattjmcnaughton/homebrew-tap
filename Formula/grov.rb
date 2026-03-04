class Grov < Formula
  desc "Service orchestrator for local development with per-worktree isolation"
  homepage "https://github.com/mattjmcnaughton/grov"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/grov/releases/download/v1.0.0/grov-macos-aarch64.tar.gz"
      sha256 "89be2d1b1992d27a98741b4e39b33ec36296af9b95c67119e3aa276216a35c78"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/grov/releases/download/v1.0.0/grov-linux-x86_64.tar.gz"
      sha256 "32fdf21497ccbb384a3c6633ffff0ab8d59f1524c12b61f556a3fc5b4fdb1d3a"
    end
  end

  def install
    binary = Dir["grov-*"]&.first
    raise "grov binary not found in archive" if binary.nil?

    bin.install binary => "grov"
  end

  test do
    output = shell_output("#{bin}/grov --help")
    assert_match "grov", output
  end
end
