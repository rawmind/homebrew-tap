class ChromeTranscriber < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/chrome-transcriber"
  url "https://github.com/rawmind/chrome-transcriber/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "3606e2f3e3f2846574438422d589905094599b2874ec43db9aba96c10b4d4de6"
  license "MIT"
  head "https://github.com/rawmind/chrome-transcriber.git", branch: "master"

  depends_on "rust" => :build
  depends_on "whisper-cpp"

  def install
    system "cargo", "install", *std_cargo_args(path: "helper")
    (pkgshare/"extension").install "manifest.json", "src"
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
