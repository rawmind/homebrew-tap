class Titl < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/titl"
  url "https://github.com/rawmind/titl/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "e69639b22d10038dbdf2fc7c08db5da2eb25bec15ee9b183763ccd17b2e68681"
  license "MIT"
  head "https://github.com/rawmind/titl.git", branch: "master"

  depends_on "rust" => :build
  depends_on "whisper-cpp"

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
