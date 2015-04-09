module Augit
  class Repo
    attr_reader :regexp

    def initialize(options = {})
      @regexp = options[:regexp]
    end

    def origin
      origin = `git remote show -n origin | grep "Fetch URL:"`.match(/.*\:(.*)\./)
      origin.nil? ? origin : origin[1]
    end

    def branch_names
      `git branch -r | #{sanitize_string}`.split("\n").uniq
    end

    def merged_branches
      `git branch -r --merged master | #{sanitize_string}`.split("\n").uniq
    end

    private

    def sanitize_string
      sanitize = "grep -v master | sed \"s/ *origin\\///\" | sed \"s/ *tddium\\///\""
      regexp.nil? ? sanitize : "grep #{regexp} | #{sanitize}"
    end
  end
end
