cask "filezilla-client" do
  arch intel: "x86_64", arm: "arm64"

  version "3.67.1"
  sha256 arm:   "8072bb4b8c9359eb51cb660928f4d7a7b985b59045eeeb886bc1a67539271909",
         intel: "4cfb11de4e4a0053ef5ab11ffefe7fd804fcea2f6452a9b2e4cc2fd0a9b95f5c"

  url "https://filezilla-project.org/download.php?platform=macos-#{arch}",
      user_agent: :fake do |page|
    page[%r{href=['"](http[s]?://.*/FileZilla_[0-9]+\.[0-9]+\.[0-9]+_macos-[a-z0-9]+.app.t.*?)['"]}i, 1]
  end
  name "filezilla-client"
  desc "Free FTP solution"
  homepage "https://filezilla-project.org/index.php"

  livecheck do
    url :url
    strategy :extract_plist
  end

  depends_on macos: ">= :high_sierra"

  app "FileZilla.app"
  binary "#{appdir}/FileZilla.app/Contents/MacOS/fzputtygen"
  binary "#{appdir}/FileZilla.app/Contents/MacOS/fzsftp"
  binary "#{appdir}/FileZilla.app/Contents/MacOS/fzstorj"
  binary "#{appdir}/FileZilla.app/Contents/MacOS/filezilla"

  zap trash: [
    "~/Library/Preferences/org.filezilla-project.filezilla.plist",
    "~/Library/Saved Application State/org.filezilla-project.filezilla.savedState",
  ]
end
