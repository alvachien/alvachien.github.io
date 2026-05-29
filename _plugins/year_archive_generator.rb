module Jekyll
  class YearArchivePage < Page
    def initialize(site, year)
      @site = site
      @base = site.source
      @dir = "/archives/#{year}"
      @name = "index.html"
      process(@name)
      read_yaml(@base, "")
      data.merge!(
        "layout" => "year-archive",
        "title" => "#{year} 年归档",
        "archive_year" => year.to_s,
        "author_profile" => true,
        "permalink" => "/archives/#{year}/"
      )
    end
  end

  class YearArchiveGenerator < Generator
    safe true

    def generate(site)
      years = site.posts.docs.group_by { |p| p.date.year }.keys.sort.reverse
      years.each { |year| site.pages << YearArchivePage.new(site, year) }
    end
  end
end
