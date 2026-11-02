class HpyAlpha < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-alpha.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.25/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4d95fbf2df964cb6ecc37f17d715c2d60e57b44500b0326ff36c0dc86e326d01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.25/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "870a04eb6cfffbb3849e5eb251b833d415800cc07717c62d924e8e20045d3936"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.25/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fc52e9ce058b8e82f1210662916d451c0cd726ed4f5c22f9c77e8d3a6158d376"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-alpha.25/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "27fdd64b0298eec886a0784b7ee268e8260f5efe8ed8cf21efb53b20fc0280ab"
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
