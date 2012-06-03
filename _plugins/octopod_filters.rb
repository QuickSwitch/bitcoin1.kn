require 'erb'

module Jekyll
  module OctopodFilters

    # Escapes CDATA sections in post content
    def cdata_escape(input)
      input.gsub(/<!\[CDATA\[/, '&lt;![CDATA[').gsub(/\]\]>/, ']]&gt;')
    end

    # Replaces relative urls with full urls
    def expand_urls(input, url='')
      url ||= '/'
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
        $1+url+$3
      end
    end

    # Formats a Time to be RSS compatible like "Wed, 15 Jun 2005 19:00:00 GMT"
    #
    # {{ site.time | time_to_rssschema }}
    def time_to_rssschema(time)
      time.strftime("%a, %d %b %Y %H:%M:%S %z")
    end

    # Returns the first argument if it's not nil or empty otherwise it returns
    # the second one.
    #
    # {{ post.author | otherwise:site.author }}
    def otherwise(first, second)
      first.nil? || first.empty? ? second : first
    end

    # Returns an <audio> tag for the given file. As a second argument it takes
    # one of the three possible preload behaviors auto/metadata/none.
    #
    # {{ 'audiofile.m4a' | audio }}
    def audio(filename, preload = nil)
      return if filename.nil?
      preload ||= 'none'
      %Q{<audio src="/files/episodes/#{ERB::Util.url_encode(filename)}" preload="#{preload}" />}
    end

    # Gets a number of seconds and returns an human readable duration string of
    # it.
    #
    # {{ 1252251 | string_of_duration }} => "00:03:13"
    def string_of_duration(duration)
      seconds = duration.to_i
      minutes = seconds / 60
      hours   = minutes / 60

      "#{"%02d" % hours}:#{"%02d" % (minutes % 60)}:#{"%02d" % (seconds % 60)}"
    end

    # Gets a number of bytes and returns an human readable string of it.
    #
    # {{ 1252251 | string_of_size }} => "1.19M"
    def string_of_size(bytes)
      bytes = bytes.to_i.to_f
      out = '0'
      return out if bytes == 0.0

      jedec = %w[b K M G]
      [3, 2, 1, 0].each { |i|
        if bytes > 1024 ** i
          out = "%.2f#{jedec[i]}" % (bytes / 1024 ** i)
          break
        end
      }

      return out
    end

  end
end

Liquid::Template.register_filter(Jekyll::OctopodFilters)
