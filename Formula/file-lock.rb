class FileLock < Formula
  desc "Encrypt declared sensitive files to protect them from coding agents"
  homepage "https://github.com/mattjmcnaughton/file-lock"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/file-lock/releases/download/v1.0.0/file-lock-macos-arm64.tar.gz"
      sha256 "09ecf453453fed0c7d1099a200965a5a421e488dff57292df126d0aaa457c580"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/file-lock/releases/download/v1.0.0/file-lock-macos-x86_64.tar.gz"
      sha256 "6b0d0aed419df8bb8e680f0dc4f7d0a67736e0dc1098f6d180dbcffabf1a0a55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/file-lock/releases/download/v1.0.0/file-lock-linux-arm64.tar.gz"
      sha256 "3e5fa83a6740ecdf15a5dde4122785b35ade3e16d6b14396344cdf3a13ebeeab"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/file-lock/releases/download/v1.0.0/file-lock-linux-x86_64.tar.gz"
      sha256 "80ba8730f802e435d6cf041204db08b320d007c7c1f9cc862d4e6ff4198680ab"
    end
  end

  def install
    binary = Dir["file-lock-*"]&.first
    raise "file-lock binary not found in archive" if binary.nil?

    bin.install binary => "file-lock"
  end

  test do
    output = shell_output("#{bin}/file-lock --help")
    assert_match "Locking and unlocking files with age encryption", output
  end
end
