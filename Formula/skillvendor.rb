class Skillvendor < Formula
  desc "Vendor remote skills from git repositories into local skill directories"
  homepage "https://github.com/mattjmcnaughton/skillvendor"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.0/skillvendor-macos-arm64.tar.gz"
      sha256 "6a9a5fa4b1930a58dc22c53ccb1810fc7c904e0fa094d337d5d266f393af4d80"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.0/skillvendor-macos-x86_64.tar.gz"
      sha256 "ee6cc37854ae09c817a8e13433dbe49141f2554eaa331dd6d972b90468ca9f41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.0/skillvendor-linux-arm64.tar.gz"
      sha256 "ca1938d3b1ad98fbf39847017728dc714e62d62b4df2bc0079141300a2224cfd"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/skillvendor/releases/download/v1.0.0/skillvendor-linux-x86_64.tar.gz"
      sha256 "2d88e9a0b012c228b254358151553d4e7337a4f0e63ccc08320c4dccc95e1327"
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
