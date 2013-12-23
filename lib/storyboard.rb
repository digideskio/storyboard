module Storyboard
  autoload :VERSION,              "storyboard/version"
  autoload :CLI,                  "storyboard/cli"

  autoload :Requirements,         "storyboard/requirements"
  autoload :Video,                "storyboard/video"

  module Collectors
    autoload :Scenes,             "storyboard/extractors/scenes.rb"
    autoload :Subtitles,          "storyboard/extractors/subtitles.rb"
  end

  module Extractors
    autoload :Timestamps,         "storyboard/extractors/timestamps.rb"
    autoload :Range,              "storyboard/extractors/range.rb"
  end

  module Runners
    autoload :Base,               "storyboard/runners/base.rb"
    autoload :Book,               "storyboard/runners/book.rb"
    autoload :Gif,                "storyboard/runners/gif.rb"
    autoload :Movie,              "storyboard/runners/movie.rb"
  end

  module UI
    autoload :Console,            "storyboard/ui/console.rb"
  end  
end
