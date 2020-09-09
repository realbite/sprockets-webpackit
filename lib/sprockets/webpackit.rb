# frozen_string_literal: true

# Clive Andrews 2020
#

require 'sprockets'
require 'tempfile'
require 'json'
require 'open3'

# transform a javascript asset by running through the webpack manger.
# The file is processed if its name finishes in eg.. .webpack.js.
# The method for saving dependencies is copied from the sprockets
# sass processor.
#

module Sprockets
  class Webpackit

    DEFAULT_PATTERN = /\.webpack\.([a-z])+$/.freeze

    class << self

      # get a list of dependent filenames from the json webpack stats
      def extract_dependencies(h)
        out = []
        h['modules'].each do |m|
          if m['cacheable'] == true
            out << File.absolute_path(m['name'])
            out.concat(extract_dependencies(m)) if m['modules']
          end
        end
        out
      end

      def extract_errors(h)
        out = []
        h['modules'].each do |m|
          if m['errors'] > 0
            out << m['name']
            out.concat(extract_dependencies(m)) if m['modules']
          end
        end
        out
      end

      def mode
        @_mode ||= ENV['RACK_ENV'] || 'development'
      end

      def mode=(val)
        @_mode = val
      end

      # run a file through webpack and return the result.
      # also maintain a list of dependencies.
      def process(context, path)
        temp = Tempfile.new('sprockets')

        command = "npx webpack #{path}"\
            " --mode #{mode} --json --display normal"\
            " -o #{temp.path}"

        puts "command ='#{command}'" if $VERBOSE || $DEBUG
        stats, err, status = Open3.capture3(command)
        # stats = %x(#{command})
        hash = JSON.parse(stats)
        errors = nil
        if status.success?
          deps = extract_dependencies(hash)
          deps.each do |fname|
            next if fname == path

            context.metadata[:dependencies] << Sprockets::URIUtils.build_file_digest_uri(fname)
          end
          result = File.read(temp.path)
        else
          errors = hash['errors']
          puts errors
          result = errors.join("\n")
        end

        temp.close
        temp.unlink

        context.metadata.merge(:data => result)
      end

      def pattern=(value)
        @_pattern = Regexp.new(value)
      end

      def pattern
        @_pattern ||= DEFAULT_PATTERN
      end

      def call(input)
        context = input[:environment].context_class.new(input)
        source = input[:data]
        load_path = input[:load_path]
        filename  = input[:filename]

        path = filename[load_path.length..-1]
        if filename =~ pattern
          process(context, filename)
        else
          { :data => source }
        end
      end

    end # self

  end
end

Sprockets.register_postprocessor('application/javascript', Sprockets::Webpackit)
