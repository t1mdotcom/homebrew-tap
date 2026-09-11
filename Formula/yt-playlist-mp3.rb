class YtPlaylistMp3 < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube playlists as MP3 files, with metadata and thumbnails"
  homepage "https://github.com/t1mdotcom/yt-playlist-mp3"
  url "https://github.com/t1mdotcom/yt-playlist-mp3/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "12fe894b5a9cf11e99666b059c51f4468e01227718433c4fecb119a452429926"
  license "MIT"
  head "https://github.com/t1mdotcom/yt-playlist-mp3.git", branch: "main"

  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "yt-dlp"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yt-playlist-mp3 --version")

    check = shell_output("#{bin}/yt-playlist-mp3 --check")
    assert_match "[OK]    yt-dlp", check
    assert_match "[OK]    ffmpeg", check

    command = shell_output(
      "#{bin}/yt-playlist-mp3 --dry-run -o #{testpath}/out " \
      "https://www.youtube.com/playlist?list=PLtest",
    )
    assert_match "yt-dlp --yes-playlist", command
    assert_match "--audio-format mp3", command
  end
end
