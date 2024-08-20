class LibinotifyKqueue < Formula
  desc "Inotify shim for BSD"
  homepage "https://github.com/libinotify-kqueue/libinotify-kqueue"
  url "https://github.com/libinotify-kqueue/libinotify-kqueue/archive/refs/tags/20240724.tar.gz"

  sha256 "120398ff95336d04f3ce7ac820e0490059625976264100dcc9af9d11e992b0ca"
  license "MIT"
  head "https://github.com/libinotify-kqueue/libinotify-kqueue.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "-j#{ENV.make_jobs}"
  end

  test do
    # TODO: Add a test
    system "true"
  end
end
