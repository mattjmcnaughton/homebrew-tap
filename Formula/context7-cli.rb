class Context7Cli < Formula
  desc "CLI helper around Context7 AI workflows"
  homepage "https://github.com/mattjmcnaughton/context7-cli"
  version "1.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/context7-cli/releases/download/v1.3.0/context7-cli-macos-aarch64.tar.gz"
      sha256 "f6f698cf2e6a358bc2f7b1ac60a889ce610ac2f58ed6856bb1a5520b5a09e797"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/context7-cli/releases/download/v1.3.0/context7-cli-macos-x86_64.tar.gz"
      sha256 "fa5f7c31f011d3dcd7cc48ac9da817ea34946af89fb9ea3513511eb18deaf15f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/context7-cli/releases/download/v1.3.0/context7-cli-linux-x86_64.tar.gz"
      sha256 "e1d27627841e0c980af27dee3e04c9302f94fff234ef3140601c20e8dd178226"
    end
  end

  def install
    binary = Dir["context7-cli-*"]&.first
    raise "context7-cli binary not found in archive" if binary.nil?

    bin.install binary => "context7-cli"
  end

  test do
    output = shell_output("#{bin}/context7-cli --help")
    assert_match "CLI for Context7 API", output
  end
end
