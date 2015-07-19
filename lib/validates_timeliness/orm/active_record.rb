module ValidatesTimeliness
  module ORM
    module ActiveRecord
      extend ActiveSupport::Concern

      module ClassMethods
        public

        def timeliness_attribute_timezone_aware?(attr_name)
          create_time_zone_conversion_attribute?(attr_name, timeliness_column_for_attribute(attr_name))
        end

        def timeliness_attribute_type(attr_name)
          timeliness_column_for_attribute(attr_name).type
        end

        def timeliness_column_for_attribute(attr_name)
          if ::ActiveRecord.version < ::Gem::Version.new('4.2')
            columns_hash.fetch(attr_name.to_s) do |attr_name|
              validation_type = _validators[attr_name.to_sym].find {|v| v.kind == :timeliness }.type
              ::ActiveRecord::ConnectionAdapters::Column.new(attr_name, nil, validation_type.to_s)
            end
          else
            columns_hash.fetch(attr_name.to_s) do |attr_name|
              validation_type = _validators[attr_name.to_sym].find {|v| v.kind == :timeliness }.type
              connection = ::ActiveRecord::Base.connection
              connection.new_column(attr_name, nil, connection.lookup_cast_type(validation_type.to_s), validation_type.to_s)
            end
          end
        end

        def define_attribute_methods
          super.tap do |attribute_methods_generated|
            define_timeliness_methods(true) if attribute_methods_generated
          end
        end

        protected

        def timeliness_type_cast_code(attr_name, var_name)
          type = timeliness_attribute_type(attr_name)

          method_body = super
          method_body << "\n#{var_name} = #{var_name}.to_date if #{var_name}" if type == :date
          method_body
        end
      end

      def reload(*args)
        _clear_timeliness_cache
        super
      end

    end
    
    module ActiveRecordLessThan42
      module ClassMethods
        def allocate
          define_attribute_methods
          super
        end
      end
      
      private
      
      def init_internals
        self.class.define_attribute_methods
        super
      end
    end
    
  end
end

class ActiveRecord::Base
  include ValidatesTimeliness::AttributeMethods
  include ValidatesTimeliness::ORM::ActiveRecord
  
  if ActiveRecord.version < Gem::Version.new('4.2')
    # Rails 4.0 / 4.1 are lazy and wait until method_missing / respond_to? is called before 
    # calling define_attribute_methods. This is now quite complex and no longer works with 
    # validates timeliness when the first attribute access for a AR model is to a 
    # validates_timeliness attribute. 
    #
    # In Rails 4.2, this has changes to be less lazy and probably more robust. These patches 
    # match Rails 4.2.
    
    prepend ValidatesTimeliness::ORM::ActiveRecordLessThan42
  
    class << self
      prepend ValidatesTimeliness::ORM::ActiveRecordLessThan42::ClassMethods
    end
  end
end
