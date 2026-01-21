class RasmTui < Formula
  desc "Terminal UI for managing AWS Secrets Manager with Vim-style navigation"
  homepage "https://github.com/mattjmcnaughton/rasm-tui"
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/rasm-tui/releases/download/v1.0.1/rasm-tui-macos-aarch64.tar.gz"
      sha256 "0978bfc1e34ff6a01144ce01743e5383aa0f2e85503d691bd8066e1381bf34de"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/rasm-tui/releases/download/v1.0.1/rasm-tui-macos-x86_64.tar.gz"
      sha256 "62269cee0b93c8fd5fbd14af961ed560ca6b09ffdc3a5f89e466f9db4dabb89a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mattjmcnaughton/rasm-tui/releases/download/v1.0.1/rasm-tui-linux-x86_64.tar.gz"
      sha256 "b33e2be9c0699823306fdb718a72abf003af1116412252b411f1dd42ce729d82"
    end
  end

  def install
    binary = Dir["rasm-tui-*"]&.first
    raise "rasm-tui binary not found in archive" if binary.nil?

    bin.install binary => "rasm-tui"
  end

  test do
    assert_predicate bin/"rasm-tui", :executable?
  end
end
