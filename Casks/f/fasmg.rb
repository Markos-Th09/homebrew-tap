cask "fasmg" do
  version "l8vn"
  sha256 "1587b5296cbb85b4ef94c44f78ab84d138379c460b53e19ff767fcde38eb4bb1"

  url "https://flatassembler.net/fasmg.#{version}.zip"
  name "fasmg"
  desc "New assembly engine designed as a successor of the one used by flat assembler 1"
  homepage "https://flatassembler.net/"

  livecheck do
    url "https://flatassembler.net/download.php"
    regex(/href=["']?fasmg\.([a-z0-9]{4})\.zip/i)
    strategy :page_match
  end

  binary "source/macos/x64/fasmg", target: "fasmg"
  artifact "docs", target: "#{HOMEBREW_PREFIX}/share/fasmg/docs"
  artifact "examples", target: "#{HOMEBREW_PREFIX}/share/fasmg/examples"

  caveats do
    requires_rosetta
  end
end
