# frozen_string_literal: true

module PhlexUI
  class Sheet::Title < Base
    def template(&)
      h3(**attrs, &)
    end

    private

    def default_attrs
      {
        class: "text-lg font-semibold leading-none tracking-tight"
      }
    end
  end
end
