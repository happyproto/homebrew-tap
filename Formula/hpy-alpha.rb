class HpyAlpha < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-alpha.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.16/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "53bb0fe95452033dd12dc208de2217341537e2c91c9e6fcdbf4f0ef5ac299672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.16/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d47534764ff1dd8a4f39e8a77311b29c1a9867dc40f166267a40719784bcf453"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.16/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a522d9c2fa3df6de9f99db511fdd88c68e1464bb4a7bf32250664e01c9a0cc94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.16/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c93bf94e68978afc1f212c9b92967132235151605981036ec9207a049fd0d637"
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
