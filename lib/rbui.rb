# frozen_string_literal: true

require "json"
require "phlex"

module RBUI
  extend Phlex::Kit

  def self.setup
    yield self
    create_namespace_module if namespace
  end

  def self.create_namespace_module
    source_module = self
    mod = namespace.to_s.split("::").inject(Object) do |parent, const|
      parent.const_get(const)
    rescue
      parent.const_set(const, Module.new)
    end

    mod.singleton_class.class_eval do
      define_method :const_missing do |name|
        source_module.const_defined?(name) ? source_module.const_get(name) : super(name)
      end

      define_method :method_missing do |name, *args, &block|
        source_module.respond_to?(name) ? source_module.send(name, *args, &block) : super(name, *args, &block)
      end

      define_method :respond_to_missing? do |name, include_private = false|
        source_module.respond_to?(name) || super(name, include_private)
      end
    end
  end

  def self.namespace
    @namespace ||= nil
  end

  def self.namespace=(value)
    @namespace = value
  end
end

# Require the Base class first
require_relative "rbui/base"

# Manually require all the files
Dir.glob(File.join(__dir__, "rbui", "**", "*.rb")).sort.each { |file| require file }

# If you need to require generators (assuming they're needed)
if defined?(Rails::Generators)
  require_relative "generators/rbui/base_generator"
  require_relative "generators/rbui/install/install_generator"
  require_relative "generators/rbui/component_generator"
end
