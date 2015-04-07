require "augit/version"

module Augit
  autoload :Repo,      'augit/repo'
  autoload :Branch,    'augit/branch'
  autoload :Inspector, 'augit/inspector'
  autoload :Presenter, 'augit/presenter'

  def self.audit(options = {})
    Augit::Inspector.new.list
  end
end
