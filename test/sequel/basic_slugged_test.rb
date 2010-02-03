require File.dirname(__FILE__) + "/test_helper"

module FriendlyId
  module Test
    module Sequel
      class BasicSluggedTest < ::Test::Unit::TestCase

        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::Sequel::Core
        include FriendlyId::Test::Sequel::Slugged

      end
    end
  end
end