module Contentable
  extend ActiveSupport::Concern

  included do
    has_one :content, as: :contentable, touch: true
  end
end
