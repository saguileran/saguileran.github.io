require 'jekyll'

module AnimeFormats
  class FormatsGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      collection = site.collections['animes']
      return unless collection

      collection.docs.each do |document|
        formats = document.data['formats']
        document.data['formats'] = formats.split(/[\s,]+/) if formats.is_a?(String)
      end
    end
  end
end
