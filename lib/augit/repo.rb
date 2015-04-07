module Augit
  class Repo
    def initialize
      
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
      "grep -v master | sed \"s/ *origin\\///\" | sed \"s/ *tddium\\///\""
    end
  end
end
