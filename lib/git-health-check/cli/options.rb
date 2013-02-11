require 'optparse'

module GitHealthCheck
  module Cli

    class Options

      def initialize(argv)
        @argv = argv
        @options = {
            :threshold => 0.5,
            :limit => 10,
            :repository => Dir.pwd
        }
        @parser = OptionParser.new
        @command_class = GitHealthCheckCommand
        set_parser_options
      end

      def banner
        return <<EOB
Usage: ghc [option]

Output metrics for your Git repository.

Examples:
    ghc
    ghc -t 10
    ghc --threshold 0.2
    ghc -l 20
    ghc --threshold 5 --limit 20
    ghc -r projects/my_repo -t 10 -l 30

EOB
      end

      def set_parser_options
        @parser.banner = banner

        @parser.separator 'Options:'

        @parser.on('-v', '--version', 'Displays the gem version') { @command_class = VersionCommand }

        @parser.on('-h', '--help', 'Displays this help message') { @command_class = HelpCommand }

        @parser.on('-t', '--threshold THRESHOLD', Float, 'Specify minimum history threshold in MB (default 0.5)') do |n|
          @options[:threshold] = n
        end

        @parser.on('-l', '--limit LIMIT', Integer, 'Specify working copy results limit (default 10)') do |n|
          @options[:limit] = n
        end

        @parser.on('-r', '--repository REPOSITORY', String,
                   'Specify the repository (current directory by default)') do |repo|
          Dir.chdir repo # handles relative directories
          @options[:repository] = Dir.pwd
        end
      end

      def parse
        @parser.parse!(@argv)
        @command_class.new(@parser, @options)
      end

    end
  end
end
