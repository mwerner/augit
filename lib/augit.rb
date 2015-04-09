require 'ext/time'
require "augit/version"

module Augit
  autoload :Repo,      'augit/repo'
  autoload :Branch,    'augit/branch'
  autoload :Inspector, 'augit/inspector'
  autoload :Presenter, 'augit/presenter'

  def self.audit(options = {})
    inspector = Augit::Inspector.new(options)
    options[:status] ? inspector.status : inspector.list
  end
end
