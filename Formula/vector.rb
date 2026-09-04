# Vector is not in homebrew-core; it ships from vectordotdev/brew, and Homebrew no longer
# taps third-party dependencies on its own. This formula mirrors Vector's official release
# tarballs so "brew install asymptote-labs/tap/beacon" can depend on it. Vector stopped
# publishing macOS x86_64 builds after 0.50.0, so Intel Macs get that release.
class Vector < Formula
  desc "High-performance observability data pipeline (runs the optional Asymptote managed forwarder)"
  homepage "https://vector.dev"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://packages.timber.io/vector/0.58.0/vector-0.58.0-arm64-apple-darwin.tar.gz"
      sha256 "9182491597f1bdedb08d84a051616c62deea770a9d905b697712cc6526919449"
      version "0.58.0"
    end
    on_intel do
      url "https://packages.timber.io/vector/0.50.0/vector-0.50.0-x86_64-apple-darwin.tar.gz"
      sha256 "14b7525b9fda86856e24ac9f52035852ae4168511709080d8081ad9f01f3dec4"
      version "0.50.0"
    end
  end

  def install
    bin.install "bin/vector"
  end

  test do
    assert_match(/^vector /, shell_output("#{bin}/vector --version"))
  end
end
