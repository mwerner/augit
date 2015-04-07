I18n.enforce_available_locales = false

module Augit
  class Presenter
    include ::ActionView::Helpers::DateHelper
    include ::ActionView::Helpers::TextHelper

    attr_reader :name, :origin

    def initialize(name, origin)
      @name = name
      @origin = origin
    end

    def print
      name = "#{branch.name}".send(age_color(branch.age))
      commits = pluralize(branch.commit_count, 'commit')
      age = distance_of_time_in_words_to_now(branch.age)
      filelist = files.first(5).compact.join("\n    ").light_black
      ellipsis = "\n...\nand #{files.length - 5} more...".light_black

      puts <<-eos

#{name}
  #{branch.author}
  #{commits} - #{age} ago
  #{filelist}#{ellipsis if files.length > 5}
  #{branch.compare_url}
eos
    end

    def oneline(name, origin)
      info = branch_info(name, origin)
      puts "  #{info[:name].send(presenter.age_color(info[:age]))}"
    end

    def branch
      @branch ||= Branch.new(name, origin)
    end

    def files
      branch.files
    end

    private

    def age_color(time)
      return :red       if time < Time.now - 4 * 7 * 24 * 60 * 60 # four weeks
      return :light_yellow if time < Time.now - 1 * 7 * 24 * 60 * 60 # one week

      return :green
    end
  end
end
