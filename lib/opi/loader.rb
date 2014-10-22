module Opi
  class Loader

    class << self

      def loadcache()
        @loadcache ||= {}
      end

      def funkyload(file)
        begin
          if cache = loadcache[file]
            return if ENV['RACK_ENV'] == 'production'

            if (mtime = File.mtime(file)) > cache
              puts "[Opi::Loader]".green + " reloading: #{file}"
              load file
              loadcache[file] = mtime
            end
          else
            puts "[Opi::Loader]".green + " loading: #{file}"
            load file
            loadcache[file] = File.mtime(file)
          end
        rescue Exception => e
          puts "[Opi::Loader] Exception loading class [#{file}]: #{e.message}"
          puts e.backtrace.join("\n")
          raise e
        end
      end

      def reload!
        Dir["#{@prefix}app/**/*.rb"].each { |x| funkyload x }
      end

    end

  end
end
