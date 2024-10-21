class Fasmg < Formula
  desc "New assembly engine designed as a successor of the one used by flat assembler 1"
  homepage "https://flatassembler.net"
  url "https://flatassembler.net/fasmg.kl0e.zip"
  version "kl0e"
  sha256 "cde9826992282c237556da87576c3912ea239d23b476a5d58aabfcc95baad7ba"
  license "BSD-3-Clause"
  head "https://github.com/tgrysztar/fasmg", branch: "master"

  livecheck do
    url "https://flatassembler.net/download.php"
    regex(/href=.*?fasmg\.([0-9a-zA-Z]+)\.zip/i)
  end

  def install
    system "chmod", "+x", "./source/macos/x64/fasmg"
    system "./source/macos/x64/fasmg", "./source/macos/x64/fasmg.asm", "./fasmg"
    system "chmod", "+x", "fasmg"
    bin.install "fasmg"
    doc.install Dir["docs/*"]
    (pkgshare/"examples").install Dir["examples/*"]
  end

  test do
    includedir = pkgshare/"examples/x86/include"
    (testpath/"hello.asm").write <<~EOS
      macro format?.MachO64? variant
        match , variant
          MachO.Settings.ProcessorType = CPU_TYPE_X86_64
          MachO.Settings.FileType equ MH_OBJECT
          include '#{includedir}/format/macho.inc'
          use64
        else match =executable?, variant
          MachO.Settings.ProcessorType = CPU_TYPE_X86_64
          MachO.Settings.BaseAddress = 0x1000
          include '#{includedir}/format/macho.inc'
          use64
        else
          err 'invalid argument'
        end match
      end macro

      format MachO64 executable
      entry start

      interpreter '/usr/lib/dyld'
      uses '/usr/lib/libSystem.B.dylib'

      segment '__TEXT' readable executable

      section '__text' align 16

      start:
        mov     rax, 0x2000001
        mov     rdi, 0
        syscall
        ret
    EOS
    system bin/"fasmg", "hello.asm", "hello"
    assert_predicate testpath/"hello", :exist?
  end
end
