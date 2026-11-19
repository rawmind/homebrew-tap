class ChromeTranscriber < Formula
  desc "Titl: local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/chrome-transcriber"
  url "https://github.com/rawmind/chrome-transcriber/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a1a6c1bd2a4bbaf269be09e2cec3281b83873029f63dbfa2dd7f1a89ba0304d8"
  license "MIT"
  head "https://github.com/rawmind/chrome-transcriber.git", branch: "master"

  depends_on "rust" => :build
  depends_on "whisper-cpp"

  def install
    system "cargo", "install", *std_cargo_args(path: "helper")
    (pkgshare/"extension").install "manifest.json", "src", "icons"
  end

  def caveats
    <<~EOS
      Finish the setup (finds whisper-server, downloads a model if needed and
      registers the helper with Chrome, Chromium, Edge and Brave):
        chrome-transcriber-helper install

      Then load the extension: chrome://extensions → Developer mode →
      Load unpacked → #{opt_pkgshare}/extension
    EOS
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/chrome-transcriber-helper --help")
    assert_match "unknown command", shell_output("#{bin}/chrome-transcriber-helper bogus 2>&1", 1)
  end
end
