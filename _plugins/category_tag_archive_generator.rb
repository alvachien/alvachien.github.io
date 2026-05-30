require 'cgi'

module Jekyll
  class CategoryArchivePage < Page
    def initialize(site, category)
      @site = site
      @base = site.source
      @dir = "categories/#{category}"
      @name = "index.html"
      process(@name)
      read_yaml(@base, "")
      slug = CGI.escape(category)
      data.merge!(
        "layout" => "category-archive",
        "title" => "分类：#{category}",
        "archive_category" => category,
        "archive_slug" => slug,
        "author_profile" => true,
        "permalink" => "/categories/#{slug}/"
      )
    end
  end

  class TagArchivePage < Page
    def initialize(site, tag)
      @site = site
      @base = site.source
      @dir = "tags/#{tag}"
      @name = "index.html"
      process(@name)
      read_yaml(@base, "")
      slug = CGI.escape(tag)
      data.merge!(
        "layout" => "tag-archive",
        "title" => "标签：#{tag}",
        "archive_tag" => tag,
        "archive_slug" => slug,
        "author_profile" => true,
        "permalink" => "/tags/#{slug}/"
      )
    end
  end

  class CategoryTagArchiveGenerator < Generator
    safe true

    def generate(site)
      site.categories.each_key do |category|
        site.pages << CategoryArchivePage.new(site, category)
      end
      site.tags.each_key do |tag|
        site.pages << TagArchivePage.new(site, tag)
      end
    end
  end
end
