require 'language_pack/installers/ruby_installer'
require 'language_pack/base'
require 'language_pack/shell_helpers'

class LanguagePack::Installers::HerokuRubyInstaller
  include LanguagePack::ShellHelpers, LanguagePack::Installers::RubyInstaller

  BASE_URL = LanguagePack::Base::VENDOR_URL

  def initialize(stack)
    @fetcher = LanguagePack::Fetcher.new(BASE_URL, stack)
  end

  def fetch_unpack(ruby_version, install_dir, build = false)
    FileUtils.mkdir_p(install_dir)
    Dir.chdir(install_dir) do
      file = "#{ruby_version.version_for_download}.tgz"
      if build
        ruby_vm = "ruby"
        file.sub!(ruby_vm, "#{ruby_vm}-build")
      end
      if ruby_version.ruby_version == '1.8.7'
        puts '*** RUBY 1.8.7 DETECTED ***'
        @fetcher.fetch_untar_absolute('https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/cedar/ruby-1.8.7.tgz')
      else
        @fetcher.fetch_untar(file)
      end
    end
  end
end
