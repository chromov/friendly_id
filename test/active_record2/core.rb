require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../generic'

module FriendlyId

  module Test

    module ActiveRecord2

      module Core

        extend FriendlyId::Test::Declarative
        include Generic

        def teardown
          klass.delete_all
          other_class.delete_all
          $slug_class.delete_all
        end

        def find_method
          :find
        end

        def create_method
          :create!
        end
        
        def delete_all_method
          :delete_all
        end

        def validation_exceptions
          [ActiveRecord::RecordInvalid, FriendlyId::ReservedError, FriendlyId::BlankError]
        end

        test "should return their friendly_id for #to_param" do
          assert_match(instance.friendly_id, instance.to_param)
        end

        test "instances should be findable by their own instance" do
          assert_equal instance, klass.find(instance)
        end

        test "instances should be findable by an array of friendly_ids" do
          second = klass.create!(:name => "second_instance")
          assert_equal 2, klass.find([instance.friendly_id, second.friendly_id]).size
        end

        test "instances should be findable by an array of numeric ids" do
          second = klass.create!(:name => "second_instance")
          assert_equal 2, klass.find([instance.id.to_i, second.id.to_i]).size
        end

        test "instances should be findable by an array of numeric ids as strings" do
          second = klass.create!(:name => "second_instance")
          assert_equal 2, klass.find([instance.id.to_s, second.id.to_s]).size
        end

        test "instances should be findable by an array of instances" do
          second = klass.create!(:name => "second_instance")
          assert_equal 2, klass.find([instance, second]).size
        end

        test "instances should be findable by an array of mixed types" do
          second = klass.create!(:name => "second_instance")
          assert_equal 2, klass.find([instance.friendly_id, second]).size
        end

        test "models should raise an error when not all records are found" do
          assert_raises(ActiveRecord::RecordNotFound) do
            klass.find([instance.friendly_id, 'bad-friendly-id'])
          end
        end

        test "models should respect finder conditions" do
          assert_raise ActiveRecord::RecordNotFound do
            klass.find(instance.friendly_id, :conditions => "1 = 2")
          end
        end

        # This emulates a fairly common issue where id's generated by fixtures are very high.
        test "should continue to admit very large ids" do
          klass.connection.execute("INSERT INTO #{klass.table_name} (id, name) VALUES (2147483647, 'An instance')")
          assert klass.base_class.find(2147483647)
        end

      end
    end
  end
end
