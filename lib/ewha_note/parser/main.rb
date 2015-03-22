# encoding = utf-8
require 'iconv'

module EwhaNote
  module Parser
    class Main
      def initialize(base, out)
        @out = out
        @base = base
      end

      def run
        out_file = File.open @out, 'w'

        Traverser.new(@base, out_file).traverse

        out_file.close

        Importer.new(in_file).run
      end
    end

    class Traverser
      def initialize(path, out_file)
        @path = path
        @out_file = out_file

        puts "Traverser: from #{@path}"
      end

      def traverse
        Dir.entries(@path).each do |entry|
          next if entry == '.' || entry == '..'

          path = "#{@path}/#{entry}"

          if File.directory?(path)
            Traverser.new(path, @out_file).traverse
          else
            f = File.open(path, 'r')

            Converter.new(f).converted.each do |row|
              next if row.first.empty?
              next if row.first =~ /순번/

              title = row[3]
              provider = row[5]

              if provider =~ /(기초)|(핵심)|(일반)|(영역)교양/ || provider =~ /자료없음/
                provider = row[8]
              end

              next if provider.empty?

              @out_file.puts(([title, provider] | row).join("\t"))
            end
          end
        end
      end
    end

    class Converter
      def initialize(f)
        @file = f
        @body = @file.read
        @converted = Iconv.conv('utf-8', 'utf-16le', @body) # Nokogiri::HTML @body
        @html_doc = Nokogiri::HTML @converted
      end

      def converted
        @html_doc.xpath('//table/tr').map do |tr|
          tr.search('td').map { |td| td.text.strip }
        end
      end
    end

    class Importer
      def initialize(path)
        @path = path
      end

      def run
        f = File.open @path, 'r'
        f.each_line do |line|
          columns = line.split("\t")

          l = Lecture.new
          l.title = columns[0]
          l.provider = columns[1]
          l.extra = columns[2..-1].join "\t"

          l.save
        end
      end
    end
  end
end
