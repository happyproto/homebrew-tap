class HpyBeta < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-beta.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.3/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6b815fa57260c6855078d18a124d3360a2b1c583672f94666bd956331fce0fdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.3/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "aa8b0a827c9672a6853d3041fb45a734b6c269e506db6e3ded6df1370b36a83f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.3/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "935adeb6eb2835616ef7d433b3a3b619b4a49ea72fb8f2953893d46d21f8e2c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.3/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c6ba285257a9ab809f4d5b9752d4547e71e9709d659fbe41019e66910238ddbc"
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
