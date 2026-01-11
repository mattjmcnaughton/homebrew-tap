class Sprite < Formula
  desc "CLI for managing Sprites"
  homepage "https://sprites.dev"
  version "0.0.1-rc29"
  # license "MIT"  # TODO: confirm license

  on_macos do
    on_arm do
      url "https://sprites-binaries.t3.storage.dev/client/v#{version}/sprite-darwin-arm64.tar.gz"
      sha256 "1f21071901744bd05a2a9f348d9f0dcdcc20b54146ae6c9cb397096c22494ecf"
    end

    on_intel do
      url "https://sprites-binaries.t3.storage.dev/client/v#{version}/sprite-darwin-amd64.tar.gz"
      sha256 "7492c8d029fef0c84eb5fec877afcf9e5c73d7e1986214ec408e7a4e006613a5"
    end
  end

  on_linux do
    on_arm do
      url "https://sprites-binaries.t3.storage.dev/client/v#{version}/sprite-linux-arm64.tar.gz"
      sha256 "3c409df478d114d2cc7d5044bcd661c94d49b11770398da199a39dcaae1077d6"
    end

    on_intel do
      url "https://sprites-binaries.t3.storage.dev/client/v#{version}/sprite-linux-amd64.tar.gz"
      sha256 "e00563bff65633841898e245cfdfe4cb5c3770ef5573ddd3ab45686b67517cfe"
    end
  end

  def install
    bin.install "sprite"
  end

  def caveats
    <<~EOS
      Run `sprite login` to authenticate.
    EOS
  end

  test do
    assert_match "sprite", shell_output("#{bin}/sprite --help", 2)
  end
end
