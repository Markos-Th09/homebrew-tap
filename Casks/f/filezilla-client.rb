cask "filezilla-client" do
  arch intel: "x86_64", arm: "arm64"

  version "3.68.1"
  sha256 arm:   "af5314eea49259a921e23420fc9708e58c32e8ebe6924a2516a292e6bd71a772",
         intel: "0ceeffd68816d46e905c286327592ee7999d3569842675526c1e95cbd7209bc9"

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

  zap trash: [
    "~/Library/Preferences/org.filezilla-project.filezilla.plist",
    "~/Library/Saved Application State/org.filezilla-project.filezilla.savedState",
  ]
end
