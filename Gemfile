source "https://rubygems.org"

gem "jekyll", "~> 4.3"

gem "minimal-mistakes-jekyll"

group :jekyll_plugins do
  gem "jekyll-paginate", "~> 1.1"
  gem "jemoji", "~> 0.13.0"
  gem "jekyll-sitemap", "~> 1.4"
  gem "jekyll-octicons", "~> 19.0"
  gem "jekyll-seo-tag", "~> 2.8"
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-include-cache"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.2", :install_if => Gem.win_platform?
