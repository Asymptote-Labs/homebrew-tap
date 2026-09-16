# frozen_string_literal: true

# Vector is not in homebrew-core; it ships from vectordotdev/brew, and Homebrew no longer
# taps third-party dependencies on its own. This formula mirrors Vector's official release
# tarballs so "brew install asymptote-labs/tap/beacon" can depend on it without colliding
# with a Vector the operator already installed from vectordotdev/brew. Vector stopped
# publishing macOS x86_64 builds after 0.50.0, so Intel Macs get that release.
# Linux uses the current Vector archive so Homebrew's cross-platform tap validation
# sees an active URL for every supported package index.
class BeaconVector < Formula
  desc "High-performance observability data pipeline for Beacon managed forwarding"
  homepage "https://vector.dev"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://packages.timber.io/vector/0.58.0/vector-0.58.0-arm64-apple-darwin.tar.gz"
      sha256 "9182491597f1bdedb08d84a051616c62deea770a9d905b697712cc6526919449"
    end
    on_intel do
      url "https://packages.timber.io/vector/0.50.0/vector-0.50.0-x86_64-apple-darwin.tar.gz"
      sha256 "14b7525b9fda86856e24ac9f52035852ae4168511709080d8081ad9f01f3dec4"
    end
  end

  on_linux do
    on_arm do
      url "https://packages.timber.io/vector/0.58.0/vector-0.58.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06d9f9768feb0cb5c7cdfc12e0b737b22f1220967f5455f391a395361b5799e5"
    end
    on_intel do
      url "https://packages.timber.io/vector/0.58.0/vector-0.58.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a4634bea859a7ad7064ff3dd6f6ad7eb0e8dd4493cc41657d84da8dd66f09d09"
    end
  end

  def install
    libexec.install "bin/vector"
  end

  test do
    assert_match(/^vector /, shell_output("#{libexec}/vector --version"))
  end
end
