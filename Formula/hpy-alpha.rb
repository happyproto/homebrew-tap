class HpyAlpha < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-alpha.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.29/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "362597e360495e4e5122c4425c056a1cfe4abaaca5e8e5ce66cb3d25a026d011"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.29/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8179563dd6be434d4eac6a2aa9db58f3b3795ee105cee836cba5ef27f64d6e5a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.29/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "514db61d60ec71301ef1cbc7947bba51d63a1d8f4e7726551d780fa5e13a05db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.29/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9d85155984f3b3b455c3b8c0f526ecdc1cff2187a5814cb323cbdf139e844faa"
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
