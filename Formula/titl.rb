class Titl < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/titl"
  url "https://github.com/rawmind/titl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "a27604373d50a9a037a02176a8d7126076e88f47ab7f21be7aed7362774d3188"
  license "MIT"
  head "https://github.com/rawmind/titl.git", branch: "master"

  depends_on "rust" => :build
  depends_on "whisper.cpp"

  def install
    system "cargo", "install", *std_cargo_args(path: "helper")
    bin.install_symlink "titl" => "chrome-transcriber-helper"
    (pkgshare/"extension").install "manifest.json", "src", "icons"
  end

  def caveats
    <<~EOS
      Finish the setup (finds whisper-server, downloads a model if needed and
      registers the helper with Chrome, Chromium, Edge and Brave):
        titl install

      Then load the extension: chrome://extensions → Developer mode →
      Load unpacked → #{opt_pkgshare}/extension
    EOS
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/titl --help")
    assert_match version.to_s, shell_output("#{bin}/titl --version")
    assert_match "unknown command", shell_output("#{bin}/titl bogus 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/chrome-transcriber-helper --version")
  end
end
