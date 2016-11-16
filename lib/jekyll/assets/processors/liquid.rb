module Jekyll
  module Assets
    module Processors
      class Liquid

        def self.instance
          @instance ||= new
        end

        def self.call(input)
          instance.call(input)
        end

        # --------------------------------------------------------------------

        def self.call(context)
          jekyll = context[:environment].jekyll

          if context[:environment].parent.asset_config["features"]["liquid"] ||
              File.extname(context[:name]) == ".liquid"

            payload_ = jekyll.site_payload
            renderer = jekyll.liquid_renderer.file(context[:name])
            context[:data] = renderer.parse(context[:data]).render! payload_, \
              :filters => [Jekyll::Filters],
              :registers => {
                :site => jekyll
              }
            context
          end
        end
      end
    end
  end
end

# ----------------------------------------------------------------------------
# There might be a few missing, if there is please do let me know.
# ----------------------------------------------------------------------------

Sprockets.register_mime_type 'text/liquid', extensions: %W(.liquid .js.liquid .css.liquid .scss.liquid)
%W(text/css text/sass text/less application/javascript text/scss text/coffeescript text/javascript).each do |mime|
  Sprockets.register_transformer 'text/liquid', 'application/javascript', Jekyll::Assets::Processors::Liquid
end

__END__
Jekyll::Assets::Processors::Liquid::EXT.each do |ext|
  Sprockets.register_engine(ext, Jekyll::Assets::Processors::Liquid, {
    :silence_deprecation => true
  })
end

# ----------------------------------------------------------------------------

Jekyll::Assets::Processors::Liquid::FOR.each do |val|
  Sprockets.register_preprocessor(
    val, Jekyll::Assets::Processors::Liquid
  )
end
