class HpyAlpha < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-alpha.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.33/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "715f8097d3a6a0f640502139c03fa750fdaee99d6537efdeb332317dfef41858"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.33/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "edb2c7639a26a3e63322238866b492f8f6ec185d8ce591de9e092bb21b0d408b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.33/hpy-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "200f7c1ccd4cb242071e18c71907c7e77212dcf522f594061068d1099e57b6e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.33/hpy-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4511a0f70913baf916ee3f4c9679c273d809934afc715f296fb5c117fe774e67"
    end
  end
  license "MIT"
  conflicts_with "hpy", "hpy-beta", because: "each release channel installs the same hpy"

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
