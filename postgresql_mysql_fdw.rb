require 'formula'

class PostgresqlMysqlFdw < Formula
  version '1.0'
  homepage 'https://github.com/dpage/mysql_fdw'
  url 'https://github.com/dpage/mysql_fdw/archive/4c48adf0f9770722484c8b8dc4d7699d87044c09.tar.gz'
  sha1 '21b3c0e6156a7c3874a14e4ae056322b89fa6a7a'

  depends_on 'postgresql'
  depends_on 'mysql'
  depends_on 'cmake' => :build

  def install
    ENV["USE_PGXS"] = "1"

    system "make"
    system "make install"
  end
end
