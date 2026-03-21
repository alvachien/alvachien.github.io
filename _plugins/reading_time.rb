module Jekyll
  module Filters
    def number_of_words(input)
      return 0 if input.nil? || input.empty?
      
      stripped = input.to_s.gsub(/<[^>]+>/, '').gsub(/\s+/, ' ').strip
      
      chinese_chars = stripped.scan(/\p{Han}/).length
      
      non_chinese = stripped.gsub(/\p{Han}/, ' ').gsub(/[[:punct:]]/, ' ')
      english_words = non_chinese.split(/\s+/).reject(&:empty?).length
      
      chinese_chars + english_words
    end
  end
end

Liquid::Template.register_filter(Jekyll::Filters)