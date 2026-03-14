Jekyll::Hooks.register :site, :pre_render do |site|
  generate_tags(site)
  generate_archives(site)
end

def generate_tags(site)
  tags_dir = File.join(site.source, 'tags')
  FileUtils.mkdir_p(tags_dir) unless File.directory?(tags_dir)

  existing_files = Dir.glob(File.join(tags_dir, '*.md'))
  existing_files.each { |f| File.delete(f) }

  tag_pages = {}
  site.posts.docs.each do |post|
    post.data['tags']&.each do |tag|
      normalized = tag.downcase
      tag_pages[normalized] ||= tag
    end
  end

  tag_pages.each_value do |tag|
    filename = tag.gsub(/[<>:"\/\\|?*]/, '_').strip
    filename = "tag-#{Digest::MD5.hexdigest(tag)}" if filename.empty?

    filepath = File.join(tags_dir, "#{filename}.md")
    content = <<~CONTENT
      ---
      layout: tag
      tag: #{tag}
      permalink: "/tags/#{tag}"
      ---
    CONTENT
    File.write(filepath, content)
  end

  Jekyll.logger.info "Tags:", "Generated #{tag_pages.size} tag pages"
end

def generate_archives(site)
  archives_dir = File.join(site.source, 'archives')
  FileUtils.mkdir_p(archives_dir) unless File.directory?(archives_dir)

  years = site.posts.docs.map { |post| post.date.year }.uniq

  years.each do |year|
    filepath = File.join(archives_dir, "#{year}.md")
    content = <<~CONTENT
      ---
      layout: archive
      title: "#{year} 年归档"
      permalink: /archives/#{year}/
      year: #{year}
      ---
    CONTENT
    File.write(filepath, content)
  end

  Jekyll.logger.info "Archives:", "Generated #{years.size} year archive pages"
end