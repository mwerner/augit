require 'action_view'
require 'colorize'
require 'highline/import'

module Augit
  class Inspector
    include ::ActionView::Helpers::DateHelper
    include ::ActionView::Helpers::TextHelper
    attr_reader :term, :origin, :branches, :merged, :unmerged, :repo

    def initialize(options = {})
      @repo = Augit::Repo.new(options)
      @origin = repo.origin
      @branches = repo.branch_names
      @merged = repo.merged_branches
      @unmerged = branches - merged
      @regexp   = options[:regexp]
    end

    def list
      print "Searching remote branches:"

      if merged.any?
        merged_actions
      else
        puts "\n> All remote branches that are merged have been deleted".green
      end

      if unmerged.any?
        print_key
        unmerged_actions
      else
        puts "\n> All unmerged remote branches have been deleted".green
      end
    end

    def section_message(data, filter)
      filter = @regexp ? "matching /#{@regexp}/ " : ''
      branches = pluralize(data.length, 'branch')
      body = 'merged into master'
      message = "#{branches} #{filter}#{body}"
      data.any? ? "#{message}:" : message
    end

    def status
      puts section_message(merged, @regexp).green
      puts "  #{merged.join("\n  ")}"

      puts section_message(unmerged, @regexp).red
      puts "  #{unmerged.join("\n  ")}"
    end

    def prompt(message)
      choice = ask("#{message} |(y)es, (n)o, (q)uit|".cyan)
      choice.strip.downcase.to_sym
    end

    def merged_actions
      puts "#{pluralize(merged.length, 'branch')} merged into master:".green
      puts "  #{merged.join("\n  ")}"

      case prompt("Delete all #{merged.length} branches?")
      when :y; merged.each{|branch| delete(branch) }
      when :n;
      when :q; exit
      end
    end

    def unmerged_actions
      unmerged.each do |branch|
        presenter(branch, origin).print

        case prompt("Delete #{branch}?")
        when :y; delete(branch)
        when :n;
        when :q; exit
        end
      end
    end

    def delete(name)
      print '!'.red
      puts " Deleting: #{name}"
      `git push origin :#{name}`
      puts "Success!".green
    end

    def presenter(branch, origin)
      Augit::Presenter.new(branch, origin)
    end

    private

    def print_key
      puts "\n#{pluralize(unmerged.length, 'branch')} not merged:"
      print "RED   ".red
      puts " - Over a month old"
      print "YELLOW".light_yellow
      puts " - Over a week old"
      print "GREEN ".green
      puts " - Created this week"
    end
  end
end
