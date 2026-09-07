# Vector runs Beacon's optional Asymptote managed forwarder (`beacon endpoint connect`).
# Vector is not in homebrew-core -- it ships from vectordotdev/brew, and Homebrew no longer
# taps third-party dependencies on its own -- so this formula mirrors Vector's official
# release tarballs and Formula/beacon.rb depends on it, which is what lets a Homebrew
# install connect without a second step.
#
# The name is load-bearing: this is `beacon-vector`, NOT `vector`. Homebrew allows exactly
# one keg named `vector` no matter which tap it came from, so while the mirror was named
# `vector` this dependency made `brew install/upgrade beacon` fail outright for everyone who
# already had Vector from vectordotdev/brew -- the upstream tap, and the one vector.dev
# points at:
#
#   Error: vector is already installed from vectordotdev/brew!
#   Please `brew uninstall vector` first.
#
# No spelling of a `vector` dependency can be satisfied by both taps; only a different
# formula name can. Under its own name this keg coexists with any other Vector.
#
# The binary goes in libexec rather than bin for the same reason one level down: Homebrew
# never links libexec into the prefix, so this keg cannot collide with another keg's
# bin/vector symlink either, and it never shadows a `vector` the user put on their PATH.
# Beacon finds it by path at #{HOMEBREW_PREFIX}/opt/beacon-vector/libexec/vector -- see
# FindVector in cli/beacon/internal/endpoint/asymptote/vector.go in agent-beacon, which
# pins that path and this formula name in a test. Renaming either side alone leaves
# `brew install beacon` installing a Vector that `beacon endpoint connect` cannot see.
#
# macOS only, matching the tarballs mirrored here; beacon.rb guards the dependency with
# `if OS.mac?` and Homebrew-on-Linux uses the vector.dev package instead. Vector stopped
# publishing macOS x86_64 builds after 0.50.0, so Intel Macs get that release -- which is
# still at or above the 0.50 minimum the forwarder needs.
class BeaconVector < Formula
  desc "Vector build that runs Beacon's optional Asymptote managed forwarder"
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
    libexec.install "bin/vector"
  end

  def caveats
    <<~EOS
      Vector is installed at #{opt_prefix}/libexec/vector and is deliberately kept off your
      PATH, so it never collides with a Vector you install yourself. Beacon finds it
      there on its own; nothing else needs to be configured.
    EOS
  end

  test do
    assert_match(/^vector /, shell_output("#{libexec}/vector --version"))
  end
end
