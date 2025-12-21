class Rtree < Formula
  desc "Fast, deterministic directory tree visualization tool written in Rust"
  homepage "https://github.com/mattjmcnaughton/rtree"
  version "1.1.0"
  license "GPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/rtree/releases/download/v1.1.0/rtree-macos-aarch64.tar.gz"
      sha256 "d3317511e469e4aedcb7eef6ca782dc143a53be3cb68a49d9cecaf3d69d51439"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/rtree/releases/download/v1.1.0/rtree-macos-x86_64.tar.gz"
      sha256 "1093d6c8d8cc6e611f3c8a4656beabc5b53a635d266091d5e9cbb9602e9cbeed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/rtree/releases/download/v1.1.0/rtree-linux-x86_64.tar.gz"
      sha256 "ec2ac870c5b51f3db701753dcb71a23ca8125090972ecc95d76fb6ee53a5c105"
    end
  end

  def install
    binary = Dir["rtree-*"]&.first
    raise "rtree binary not found in archive" if binary.nil?

    bin.install binary => "rtree"
    bin.install_symlink "rtree" => "tree"
  end

  test do
    output = shell_output("#{bin}/rtree --help")
    assert_match "directory tree", output
  end
end
