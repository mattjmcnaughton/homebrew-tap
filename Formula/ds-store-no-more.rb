class DsStoreNoMore < Formula
  desc "CLI for cleaning up .DS_Store files and other unwanted filesystem clutter"
  homepage "https://github.com/mattjmcnaughton/ds-store-no-more"
  version "1.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/ds-store-no-more/releases/download/v1.1.1/ds-store-no-more-macos-aarch64.tar.gz"
      sha256 "b7241a3e6981fd8fd5da8d967539866e94a8998b2252807f29aac9511a0ca15d"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/ds-store-no-more/releases/download/v1.1.1/ds-store-no-more-macos-x86_64.tar.gz"
      sha256 "b357df585607bf9e71cfb7b46ad53b9fce768e11081b0a2017b30a97c938e5b3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/ds-store-no-more/releases/download/v1.1.1/ds-store-no-more-linux-x86_64.tar.gz"
      sha256 "02ef2dfb2181ffb1c1393adf49689d8e51f98eb0d61f934b275f6609f5bdd674"
    end
  end

  def install
    binary = Dir["ds-store-no-more-*"]&.first
    raise "ds-store-no-more binary not found in archive" if binary.nil?

    bin.install binary => "ds-store-no-more"
  end

  test do
    output = shell_output("#{bin}/ds-store-no-more --help")
    assert_match "cleaning up", output
  end
end
