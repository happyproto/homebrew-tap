class HpyBeta < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.1/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bc91eabb470d021df556a94a85a8bbbb4cab3f455842253e97dedaa6792259ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.1/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "392b92fd557a598d3ad89aa4da50ed44a6da9e0605de0e90d93adae1a0bf7adb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.1/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "baaa7381c520adf275f0af93f3e142a889e107fb1952eb019c77bf6185842a1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.1/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "42fb99aa5eec95f8ce0f5e2d3dcfc39db549280b736e300ec0f8c9dcb9f79bcc"
    end
  end
  license "MIT"
  conflicts_with "hpy", "hpy-alpha", because: "each release channel installs the same hpy"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hpy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hpy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hpy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hpy"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
