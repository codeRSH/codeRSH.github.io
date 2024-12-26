module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      # Use a hash to store normalized tags
      tag_mapping = {}
      
      # Collect all tags and normalize them
      site.posts.docs.each do |post|
        post.data['tags']&.each do |tag|
          # Normalize the tag (lowercase)
          normalized_tag = tag.downcase
          
          # Store the original tag to preserve case in display
          tag_mapping[normalized_tag] = tag unless tag_mapping.key?(normalized_tag)
          
          # Update the post's tag to use the normalized version
          post.data['tags'] = post.data['tags'].map { |t| t.downcase }
        end
      end

      # Generate pages for unique normalized tags
      tag_mapping.each do |normalized_tag, original_tag|
        site.pages << TagPage.new(site, site.source, 'tag', normalized_tag, original_tag)
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, normalized_tag, display_tag)
      @site = site
      @base = base
      @dir = dir
      @name = "#{normalized_tag}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['title'] = "Posts tagged with "#{display_tag}""
      self.data['tag'] = normalized_tag
      self.data['display_tag'] = display_tag
    end
  end
end
