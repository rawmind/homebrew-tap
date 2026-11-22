class Titl < Formula
  desc "Local whisper.cpp subtitles and translation for YouTube in Chrome"
  homepage "https://github.com/rawmind/titl"
  url "https://github.com/rawmind/titl/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "07198be046fe7dbebea813c2ec36989e035d08783966b49ec3a56553ca48df58"
  license "MIT"
  head "https://github.com/rawmind/titl.git", branch: "master"

  depends_on "rust" => :build
  depends_on "whisper.cpp"

  def install
    system "cargo", "install", *std_cargo_args(path: "helper")
    (pkgshare/"extension").install "manifest.json", "src", "icons", "_locales"
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
  end
end
