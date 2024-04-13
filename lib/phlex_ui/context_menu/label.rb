# frozen_string_literal: true

module PhlexUI
  class ContextMenu::Label < Base
    def initialize(inset: false, **attrs)
      @inset = inset
      super(**attrs)
    end

    def template(&)
      div(**attrs, &)
    end

    private

    def inset? = @inset

    def default_attrs
      {
        class: tokens("px-2 py-1.5 text-sm font-semibold text-foreground", inset?: "pl-8")
      }
    end
  end
end
