class FetchContext < Formula
  desc "Pull external context (repos, web pages) into the current repo for agents"
  homepage "https://github.com/mattjmcnaughton/fetch-context"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.0/fetch-context-macos-arm64.tar.gz"
      sha256 "61443bc51ef053d30939650ebcecf2dd05d43ea7d2b7522849f290486963d6d6"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.0/fetch-context-macos-x86_64.tar.gz"
      sha256 "91238ff29c52164e5f4cc114ada2091cd34aea03a98e222337a9752153ca4d21"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.0/fetch-context-linux-arm64.tar.gz"
      sha256 "202cc3792f494c2e16565a3a154af557c3ae66a40fb4eb17a452121144c6ea94"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/fetch-context/releases/download/v1.0.0/fetch-context-linux-x86_64.tar.gz"
      sha256 "6b825c0236083adabf9c51c98f46a88bf14bfc6c3007997c7c12968c67f408de"
    end
  end

  def install
    binary = Dir["fetch-context-*"]&.first
    raise "fetch-context binary not found in archive" if binary.nil?

    bin.install binary => "fetch-context"
  end

  test do
    output = shell_output("#{bin}/fetch-context version")
    assert_match "1.0.0", output
  end
end
