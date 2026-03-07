class Grov < Formula
  desc "Service orchestrator for local development with per-worktree isolation"
  homepage "https://github.com/mattjmcnaughton/grov"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/grov/releases/download/v1.1.0/grov-macos-aarch64.tar.gz"
      sha256 "93adc70fa85e254dbcdc1002a43525380671b4626b2d6891a57057525c73ef73"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/grov/releases/download/v1.1.0/grov-linux-x86_64.tar.gz"
      sha256 "5217cc790e8342d60655df25651fe19783bfdde5cbb545c92a9eec7203c12d88"
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
