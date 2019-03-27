class Mint < Formula
  desc "Dependency manager that installs and runs Swift command line tool packages"
  homepage "https://github.com/jaredh/Mint"
  url "https://github.com/jaredh/Mint/archive/0.8.1.tar.gz"
  sha256 "395408a3dc9c3db2b5c200b8722a13a60898c861633b99e6e250186adffd1370"
  head "https://github.com/jaredh/Mint.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
