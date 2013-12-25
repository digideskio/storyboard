module Storyboard::Runners
  class Base
    attr_reader :ui, :options, :parser, :workdirectory

    attr_reader :video, :subtitles, :extractor
    attr_reader :start_time, :end_time

    def self.run(parser, options, ui=Storyboard::UI::Console)
      Storyboard::Binaries.check
      # catch exceptions from the above, and prompt to install if 
      # there are known good options.
      self.new(parser,options,ui).run
    end

    def initialize(parser, options, ui=Storyboard::UI::Console)
      @options = options
      @ui = ui.new(self)
      @parser = parser
      extract_path_arguments!

      @video = Storyboard::Video.new(self)
      @workdirectory = Dir.mktmpdir
      @ui.log("Will be saving files to #{@options['_output_director']}")      

      at_exit do
        @ui.log("Cleaning up #{@workdirectory}")
        FileUtils.remove_entry @workdirectory
      end
    end

    def run
      raise NotImplementedError
    end

    private
    def ts_to_s(timecode)
      tot = 0
      sixes, ms = timecode.split('.')
      times = sixes.split(':').map(&:to_i).reverse.each_with_index{|v,i| tot += (60**i) * v }
      tot += (ms.to_i / 100.0)
      tot
    end

    def pull_options!
      @start_time = ts_to_s(@options[:start_time]) if @options[:start_time_given]
      @end_time = ts_to_s(@options[:end_time]) if @options[:end_time_given]

      if @options[:dimensions_given]
        width, height = @video.width, nil
        if @options[:dimensions].end_with?('%')
          width = (@options[:dimensions].to_i / 100.to_f) * @video.width
        else
          width, height = @options[:dimensions].split('x')
        end
        @extractor.filters << "scale=#{width}:#{height || -1}"
      end
    end

    def extract_path_arguments!
      while not ARGV.empty? do
        last_arg = File.expand_path(ARGV.pop)
        if File.directory?(last_arg) && File.writable?(last_arg)
          @options['_output_director'] = last_arg
        elsif File.file?(last_arg) && File.readable?(last_arg)
          @options['_video'] = last_arg
        end
        @options['_output_director'] ||= Dir.pwd
      end

    end
  end
end
