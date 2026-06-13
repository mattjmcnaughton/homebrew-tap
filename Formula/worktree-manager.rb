class WorktreeManager < Formula
  desc "Go CLI for managing Git worktrees as task-oriented development environments"
  homepage "https://github.com/mattjmcnaughton/worktree-manager"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mattjmcnaughton/worktree-manager/releases/download/v1.0.0/worktree-manager-macos-arm64.tar.gz"
      sha256 "62ec57644ea8cea6666519fdbb6703615b255fd2bdc82a7d30f526dbe851d59b"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/worktree-manager/releases/download/v1.0.0/worktree-manager-macos-x86_64.tar.gz"
      sha256 "1040cc3522bd7a57e60e41f46bb5cc9cd779b8e8a46eafab003dfd7e8243f626"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mattjmcnaughton/worktree-manager/releases/download/v1.0.0/worktree-manager-linux-arm64.tar.gz"
      sha256 "4d3144217793257705f6e63854f8d2f1d24707163049bc4e66aa32e3308edae3"
    end

    on_intel do
      url "https://github.com/mattjmcnaughton/worktree-manager/releases/download/v1.0.0/worktree-manager-linux-x86_64.tar.gz"
      sha256 "21746340c3e02aea6c2a991286b9a879bc79a9dd5ccb483bad3a98cd6b000ea0"
    end
  end

  def install
    binary = Dir["worktree-manager-*"]&.first
    raise "worktree-manager binary not found in archive" if binary.nil?

    bin.install binary => "worktree-manager"
  end

  test do
    output = shell_output("#{bin}/worktree-manager --help")
    assert_match "worktree", output
  end
end
