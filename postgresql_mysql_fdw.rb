require 'formula'

class MySqlInstalled < Requirement
  fatal true

  satisfy { which 'mysql_config' }

  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql
    EOS
  end
end

class PostgresqlMysqlFdw < Formula
  version '1.0'
  homepage 'https://github.com/dpage/mysql_fdw'
  url 'https://github.com/dpage/mysql_fdw/archive/4c48adf0f9770722484c8b8dc4d7699d87044c09.tar.gz'
  sha1 '21b3c0e6156a7c3874a14e4ae056322b89fa6a7a'

  depends_on MySqlInstalled
  depends_on :postgresql
  depends_on 'cmake' => :build

  def postgresql
    # Follow the PostgreSQL linked keg back to the active Postgres installation
    # as it is common for people to avoid upgrading Postgres.
    Formula.factory('postgresql').linked_keg.realpath
  end

  def install
    ENV["USE_PGXS"] = "1"

    system "make"
    system "make install"
  end
end
