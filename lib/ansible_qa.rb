require "ansible_qa/version"
require "ansible_qa/checks/base_check"
require "ansible_qa/checks/Gemfile"
require "ansible_qa/checks/Ackrc"

module AnsibleQA
  class Base

    def self.new
    end

    def self.check
      gemfile = AnsibleQA::Checks::Gemfile.new('Gemfile')
      gemfile.check
    end

    def self.root_dir(path = nil)
      @root_dir = path if path
      @root_dir
    end

    def self.tmp_root_dir(path = nil)
      @tmp_root_dir = path if path
      @tmp_root_dir
    end

  end

end