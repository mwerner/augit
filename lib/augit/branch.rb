module Augit
  class Branch
    include ::ActionView::Helpers::DateHelper

    attr_reader :name, :author, :origin, :commits, :age

    CHANGE_MAP = [
      { name: 'commit',    regex: /^commit\s(.*)/ },
      { name: 'author',    regex: /^Author:\s(.*)\s</ },
      { name: 'timestamp', regex: /^Date:\s*(.*)$/ },
      { name: 'file',      regex: /^:.*\s(.*)/ }
    ]

    def initialize(name, origin)
      @name = name
      @origin = origin
      @commits = {}
      @age = Time.now

      populate
    end

    def compare_url
      "https://github.com/#{origin}/compare/#{name}"
    end

    def files
      commits.values.flatten.uniq
    end

    def commit_count
      commits.keys.length
    end

    private

    def populate
      sha = nil

      changes.each do |line|
        next if line.nil? || line == ''

        CHANGE_MAP.each do |check|
          value = line.match(check[:regex])
          next if value.nil?

          case check[:name].to_sym
          when :commit
            sha = value[1]
            @commits[sha] ||= []
          when :author
            @author = value[1]
          when :file
            @commits[sha] << value[1] unless sha.nil?
          when :timestamp
            committed_at = Time.parse(value[1])
            @age = committed_at if committed_at < @age
          end
        end
      end
    end

    def changes
      `git whatchanged --abbrev-commit master.. origin/#{name}`.split("\n")
    end
  end
end
