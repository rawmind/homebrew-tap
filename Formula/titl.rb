class Titl < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/titl"
  url "https://github.com/rawmind/titl/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "f84b51c9ee2772133c5f5dea262521d0852fc6cf3baa8074672832f874f7a66a"
  license "MIT"
  head "https://github.com/rawmind/titl.git", branch: "master"

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
