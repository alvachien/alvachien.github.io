Jekyll::Hooks.register :site, :after_init do |site|
  tags_dir = File.join(site.source, 'tags')
  archives_dir = File.join(site.source, 'archives')
  
  FileUtils.mkdir_p(tags_dir) unless File.directory?(tags_dir)
  FileUtils.mkdir_p(archives_dir) unless File.directory?(archives_dir)

  existing_tags = Dir.glob(File.join(tags_dir, '*.md'))
  existing_tags.each { |f| File.delete(f) }

  existing_archives = Dir.glob(File.join(archives_dir, '*.md'))
  existing_archives.each { |f| File.delete(f) }

  FileUtils.touch(File.join(tags_dir, '.gitkeep'))
  FileUtils.touch(File.join(archives_dir, '.gitkeep'))
end

Jekyll::Hooks.register :site, :post_read do |site|
  generate_tag_pages(site)
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