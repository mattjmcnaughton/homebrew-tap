class FetchContext < Formula
  desc "Pull external context (repos, web pages) into the current repo for agents"
  homepage "https://github.com/mattjmcnaughton/fetch-context"
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.1/fetch-context-macos-arm64.tar.gz"
      sha256 "049df92360e2815c109de1da2584d34bd4c9ce00491030d6b8e02c638f12f92b"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.1/fetch-context-macos-x86_64.tar.gz"
      sha256 "59cb4e53acd2a6fc91350e35062aafb5f16946b5de04c94db0b62cf64ffeba8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.1/fetch-context-linux-arm64.tar.gz"
      sha256 "79c199f6d9551c678e7b8c6b325b940f30fd853b637475310eaf8d9bed64bde7"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.1/fetch-context-linux-x86_64.tar.gz"
      sha256 "3f2639d9431a25a43208e55720e29cd646ca2012ad5b95e4fa1ed2c82f1c59b1"
    end
  end

  def install
    binary = Dir["fetch-context-*"]&.first
    raise "fetch-context binary not found in archive" if binary.nil?

    bin.install binary => "fetch-context"
  end

  test do
    output = shell_output("#{bin}/fetch-context version")
    assert_match "1.0.1", output
  end
end
