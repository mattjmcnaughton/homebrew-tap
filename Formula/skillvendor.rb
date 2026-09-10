class Skillvendor < Formula
  desc "Vendor remote skills from git repositories into local skill directories"
  homepage "https://github.com/mattjmcnaughton/skillvendor"
  version "1.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.2.0/skillvendor-macos-arm64.tar.gz"
      sha256 "3b0253c13e64ed18efb885c0ed468e477533d08af14c30edc460e0ab9b14c1f2"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.2.0/skillvendor-macos-x86_64.tar.gz"
      sha256 "d663361e3136b8d06a210b9f93e529fd79cb0b52152a3549d2c9b3bb9378b0f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.2.0/skillvendor-linux-arm64.tar.gz"
      sha256 "cbfa4edd53febe4091d5df2ddb8e25c105559df17a3f0105a76bef75cb9e2be2"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.2.0/skillvendor-linux-x86_64.tar.gz"
      sha256 "edaa3190f51b63b52eccd68d5b55e15d002ca2c84dc5094a8b625adfa52b0514"
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
