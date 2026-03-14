Jekyll::Hooks.register :site, :post_read do |site|
  generate_tag_pages(site)
  generate_category_pages(site)
  generate_archive_pages(site)
end

def generate_tag_pages(site)
  tag_pages = {}
  site.posts.docs.each do |post|
    post.data['tags']&.each do |tag|
      tag_str = tag.to_s
      normalized = tag_str.downcase
      tag_pages[normalized] ||= tag_str
    end
  end

  tag_pages.each_value do |tag|
    filename = tag.gsub(/[<>:"\/\\|?*]/, '_').strip
    filename = "tag-#{Digest::MD5.hexdigest(tag)}" if filename.empty?

    page = Jekyll::PageWithoutAFile.new(site, site.source, 'tags', "#{filename}.md")
    page.content = ''
    page.data = {
      'layout' => 'tag',
      'tag' => tag,
      'permalink' => "/tags/#{tag}/"
    }
    site.pages << page
  end

  Jekyll.logger.info "Tags:", "Generated #{tag_pages.size} tag pages"
end

def generate_category_pages(site)
  category_pages = {}
  site.posts.docs.each do |post|
    post.data['categories']&.each do |category|
      cat_str = category.to_s
      normalized = cat_str.downcase
      category_pages[normalized] ||= cat_str
    end
  end

  category_pages.each_value do |category|
    filename = category.gsub(/[<>:"\/\\|?*]/, '_').strip
    filename = "cat-#{Digest::MD5.hexdigest(category)}" if filename.empty?

    page = Jekyll::PageWithoutAFile.new(site, site.source, 'categories', "#{filename}.md")
    page.content = ''
    page.data = {
      'layout' => 'category',
      'category' => category,
      'permalink' => "/categories/#{category}/"
    }
    site.pages << page
  end

  Jekyll.logger.info "Categories:", "Generated #{category_pages.size} category pages"
end

def generate_archive_pages(site)
  years = site.posts.docs.map { |post| post.date.year }.uniq

  years.each do |year|
    page = Jekyll::PageWithoutAFile.new(site, site.source, 'archives', "#{year}.md")
    page.content = ''
    page.data = {
      'layout' => 'archive',
      'title' => "#{year} 年归档",
      'permalink' => "/archives/#{year}/",
      'year' => year
    }
    site.pages << page
  end

  Jekyll.logger.info "Archives:", "Generated #{years.size} year archive pages"
end