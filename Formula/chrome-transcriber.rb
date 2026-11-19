class ChromeTranscriber < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/chrome-transcriber"
  url "https://github.com/rawmind/chrome-transcriber/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e5f6169af415d73b300e1bd5cfae1a670b12fec5254cf017276c6cd197f6d65a"
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
