ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Bootsnap's Windows file loader cannot open this project's non-ASCII path.
ENV["DISABLE_BOOTSNAP"] ||= "1" if Gem.win_platform? && !__dir__.ascii_only?
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
