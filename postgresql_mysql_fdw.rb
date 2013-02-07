require 'formula'

class PostgresqlMysqlFdw < Formula
  version '1.0'
  homepage 'https://github.com/dpage/mysql_fdw'
  url 'https://github.com/dpage/mysql_fdw/archive/4c48adf0f9770722484c8b8dc4d7699d87044c09.tar.gz'
  sha1 '21b3c0e6156a7c3874a14e4ae056322b89fa6a7a'

  depends_on :mysql
  depends_on 'postgresql'
  depends_on 'cmake' => :build

  def postgresql
    # Follow the PostgreSQL linked keg back to the active Postgres installation
    # as it is common for people to avoid upgrading Postgres.
    Formula.factory('postgresql').linked_keg.realpath
  end

  def install
    ENV.append("USE_PGXS", "1")

    system "make"

    # mysql_fdw includes the PGXS makefiles and so will install __everything__
    # into the Postgres keg instead of the mysql_fdw keg. Unfortunately, some
    # things have to be inside the Postgres keg in order to be function. So, we
    # install everything to a staging directory and manually move the pieces
    # into the appropriate prefixes.
    mkdir 'stage'
    system 'make', 'install', "DESTDIR=#{buildpath}/stage"

    so = Dir['stage/**/*.so']
    extensions = Dir['stage/**/extension/*']

    (postgresql/'lib').install so

    # Install extension scripts to the Postgres keg.
    # `CREATE EXTENSION mysql_fdw;` won't work if these are located elsewhere.
    (postgresql/'share/postgresql/extension').install extensions
  end
end
