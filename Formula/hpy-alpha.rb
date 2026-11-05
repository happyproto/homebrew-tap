class HpyAlpha < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-alpha.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.31/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2569a87e8d79fdbe9f7019b9fb8d3cf7702e4122d132730a31fac2f3c109f1c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.31/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a863932d66b819764493c0223d2dca72170e06a7316e74f1cecf837a19ac28a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.31/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fd1b5334a70b63d89e8786891a3d883e7e0bb515d8a0d8ecc57374751a4dddac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.31/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "128e1b44872692995da77d37127df6afa1a6a6a879449cd813ee1b273c2db8f4"
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
