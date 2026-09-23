# frozen_string_literal: true

# Vector is not in homebrew-core; it ships from vectordotdev/brew, and Homebrew no longer
# taps third-party dependencies on its own. This formula mirrors Vector's official release
# tarballs so "brew install asymptote-labs/tap/beacon" can depend on it without colliding
# with a Vector the operator already installed from vectordotdev/brew. Vector stopped
# publishing macOS x86_64 builds after 0.50.0, so Intel Macs get that release.
#
# Pinned to 0.56.0, the version Beacon's .pkg, .deb, and .rpm ship. Vector 0.57 stops
# expanding ${VAR:-default} in config files and 0.58 stops expanding ${VAR} at all without
# --dangerously-allow-env-var-interpolation, which breaks the forwarding configs Beacon
# generates. Move past 0.56 only together with agent-beacon, whose CI checks every generated
# config against the Vector it ships.
#
# Linux uses the static (musl) build, the same one Beacon's Linux packages carry. Beacon's own
# formula does not depend on this one on Linux, but the URLs keep Homebrew's cross-platform tap
# validation happy.
class BeaconVector < Formula
  desc "High-performance observability data pipeline for Beacon managed forwarding"
  homepage "https://vector.dev"
  license "MPL-2.0"
  # Bumped for the move from 0.58.0 back to 0.56.0. Homebrew only upgrades to a higher version,
  # and compares version_scheme first, so without this `brew upgrade` leaves 0.58.0 installed.
  version_scheme 1

  on_macos do
    on_arm do
      url "https://packages.timber.io/vector/0.56.0/vector-0.56.0-arm64-apple-darwin.tar.gz"
      sha256 "9aa8b6772d7c887734d38c84eb721d3a067e08a4aa4dc0dcc809365da242ec16"
    end
    on_intel do
      url "https://packages.timber.io/vector/0.50.0/vector-0.50.0-x86_64-apple-darwin.tar.gz"
      sha256 "14b7525b9fda86856e24ac9f52035852ae4168511709080d8081ad9f01f3dec4"
    end
  end

  on_linux do
    on_arm do
      url "https://packages.timber.io/vector/0.56.0/vector-0.56.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "afa383a264e7ab373dac68281cd86fb808f8447bb3813c08b5b0baaae0314a05"
    end
    on_intel do
      url "https://packages.timber.io/vector/0.56.0/vector-0.56.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8c114c5e9fd9646516f014d5d837690447cf0d4f43ba4a3746713bc0612b039b"
    end
  end

  def install
    libexec.install "bin/vector"
  end

  test do
    assert_match(/^vector /, shell_output("#{libexec}/vector --version"))
  end
end
