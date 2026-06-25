class Skillvendor < Formula
  desc "Vendor remote skills from git repositories into local skill directories"
  homepage "https://github.com/mattjmcnaughton/skillvendor"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.1.0/skillvendor-macos-arm64.tar.gz"
      sha256 "942b1f17ea45dd846b4aebfed07163ec63559732b9afa99d2490bc7be3854c97"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.1.0/skillvendor-macos-x86_64.tar.gz"
      sha256 "7dac1ad96fe58a912264de673ccaa0f562ac39a689420a7a8b9a983eb3539b00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.1.0/skillvendor-linux-arm64.tar.gz"
      sha256 "a27484f84d8d6af90601c8fe26b2155f1efc9a8481c039b8660b95e3b6e22318"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.1.0/skillvendor-linux-x86_64.tar.gz"
      sha256 "0d4a643c022d8aecf8f45eea76564b21e638f42f6d87256bbe4e36e97089ed13"
    end
  end

  def install
    binary = Dir["skillvendor-*"]&.first
    raise "skillvendor binary not found in archive" if binary.nil?

    bin.install binary => "skillvendor"
  end

  test do
    output = shell_output("#{bin}/skillvendor --help")
    assert_match "skillvendor", output
  end
end
