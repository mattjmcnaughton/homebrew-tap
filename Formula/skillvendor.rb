class Skillvendor < Formula
  desc "Vendor remote skills from git repositories into local skill directories"
  homepage "https://github.com/mattjmcnaughton/skillvendor"
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.1/skillvendor-macos-arm64.tar.gz"
      sha256 "935f6d54e632d85d760772d97fbd83ddc9f2f7e5aa21d8f94a46a08d45a69bb7"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.1/skillvendor-macos-x86_64.tar.gz"
      sha256 "c726ff2a37ba49dd1251756e93b39273a1a21ba490ff7936e1824f10dbe48d51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.1/skillvendor-linux-arm64.tar.gz"
      sha256 "49c41664993fe757849eeb1c7e5770aded4ccb11a46cbbdd0d13ade2804399b4"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.1/skillvendor-linux-x86_64.tar.gz"
      sha256 "e7bed68db80b078f4c573c57fc7b5499a00f9810da2c474bcdb9ad957b6b09cb"
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
