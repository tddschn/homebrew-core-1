class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.7.tar.gz"
  sha256 "99ff6c153c888cc514d9c4e8acfb99448ab0bdaff8ef5aaa398a1d4f00c8579f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0466e27596cec26f2fcce66fe699f4366e8e2e3c020c9c69a86e3dfe5982c81c"
    sha256 cellar: :any,                 big_sur:       "f5aa0d2c90d1bf0fdd1b01e7d540a243552054274634cc429c0364fdcbafb44a"
    sha256 cellar: :any,                 catalina:      "2ce6fa8b2b26b317a0bb5896a7bbb8a492d85788f2f7eda43cac8cc2dde7a3a4"
    sha256 cellar: :any,                 mojave:        "6fe017217defc0a4746d5881f8ced6f2ae0af262f0fa6aef33c94721f45b1742"
    sha256 cellar: :any,                 high_sierra:   "8b2a7955298fe618abe12328de07a6c991a47d15805b27f11f2df2f0bf88de0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa740b18cb787d373365b0540f47e8260a000b7b6f9281cb13f82d847d7b97f"
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
