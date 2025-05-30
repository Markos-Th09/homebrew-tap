class Fasmg < Formula
  desc "New assembly engine designed as a successor of the one used by flat assembler 1"
  homepage "https://flatassembler.net"
  url "https://flatassembler.net/fasmg.ktge.zip"
  version "g.ktge"
  sha256 "09af376d49c786d11788584687d479652584e8d48a26e04cadb6ec0ad3fe1deb"
  license "BSD-3-Clause"
  head "https://github.com/tgrysztar/fasmg.git", branch: "master"

  livecheck do
    url "https://flatassembler.net/download.php"
    regex(/href=.*?fasmg\.([0-9a-zA-Z]+)\.zip/i)
  end

  depends_on arch: :x86_64

  def install
    if OS.linux?
      os = "linux"
      fasmg = "./fasmg.x64"
    elsif OS.mac?
      os = "macos"
      fasmg = "./source/#{os}/x64/fasmg"
    else
      odie "Unsupported operating system"
    end

    cd "core" if build.head?
    chmod "+x", fasmg

    system fasmg, "./source/#{os}/x64/fasmg.asm", "./fasmg"
    chmod "+x", "fasmg"

    bin.install "fasmg"
    doc.install Dir["docs/*"]
    (pkgshare/"examples").install Dir["examples/*"]
  end

  test do
    ENV["INCLUDE"] = pkgshare/"examples/x86/include"
    format = OS.mac? ? "MachO64" : "ELF64 executable"
    entry = OS.mac? ? "_main" : "_start"
    modifier = OS.mac? ? "public" : "entry"
    strings_section = OS.mac? ? "section '__cstring' align 1" : "segment readable"
    text_section = OS.mac? ? "section '__text' align 16" : "segment readable executable"

    (testpath/"hello.asm").write <<~EOS
      include 'format/format.inc'
      format #{format}
      #{modifier} #{entry}

      SYS_write = #{OS.mac? ? "0x2000004" : "1"}
      SYS_exit = #{OS.mac? ? "0x2000001" : "60"}

      #{OS.mac? ? "segment '__TEXT' readable executable" : ""}
      #{strings_section}
      message db 'Hello, world!', 0x0A
      message_len = $ - message

      #{text_section}
      #{entry}:
        mov rax, SYS_write
        mov rdi, 1
        lea rsi, [message]
        mov rdx, message_len
        syscall
        mov rax, SYS_exit
        xor rdi, rdi
        syscall
        ret
    EOS

    if OS.mac?
      system bin/"fasmg", "hello.asm", "hello.o"
      system ENV.cc, "hello.o", "-o", "hello"
    elsif OS.linux?
      system bin/"fasmg", "hello.asm", "hello"
    end

    chmod "+x", "hello"
    assert_equal "Hello, world!\n", shell_output("./hello")
  end
end
