Jekyll::Hooks.register :site, :pre_render do |site|
  year_counts = site.posts.docs.group_by { |p| p.date.year }.transform_values(&:count)
  
  sidebar_year = site.data.dig('navigation', 'sidebar-year') || []
  
  sidebar_year.map! do |item|
    if item['title'] =~ /写过的字 - (\d{4})/
      year = $1.to_i
      count = year_counts[year] || 0
      item.merge('title' => "写过的字 - #{year} (#{count})")
    else
      item
    end
  end
  
  total_count = site.posts.docs.size
  total_item = sidebar_year.find { |i| i['title'] =~ /^写过的字（本站）/ }
  total_item['title'] = "写过的字（本站）(#{total_count})" if total_item
  
  site.data['navigation']['sidebar-year'] = sidebar_year
end