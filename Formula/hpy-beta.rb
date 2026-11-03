class HpyBeta < Formula
  desc "The HappyProto command line"
  homepage "https://happyproto.at"
  version "1.0.0-beta.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.4/hpy-cli-aarch64-apple-darwin.tar.xz"
      sha256 "05d6ffcbc353bbd3eac9de25741a2ed9094d1c07c16b29f2eb2a67ce5f3d2282"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.4/hpy-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8a19c46271cb3ed255dc3d00cd539d15a92dd13a4f65ec2cfbe49cce6b6062af"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.4/hpy-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e3e5ea48ea46626c284fc70400d64f6ddf45f8b4a4344ca414f828df17ce9a75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/happyproto/cli/releases/download/v1.0.0-beta.4/hpy-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f534f9abb9c02bfb4e579720a1bdabc09e1fe773dd4c2d80423fef012615505c"
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
