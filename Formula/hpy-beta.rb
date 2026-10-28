class HpyBeta < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-beta.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.2/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b139a5530978e5c5fe4be03d4fe61c22ebfc153c15717ff182a64e6f77dddb4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.2/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b690856cfc86e632e366afeaabb4870321a5938db292a1d460d7081d49e3da75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.2/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "469e0427889591a561d626d9c3e90ef5218a79646447929733fb35d4c46c9cbc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.2/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8b363401edd41d81b68de7837e00e1f5b9a2b3a21bd750a184e644ccba55e21f"
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
