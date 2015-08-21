module ValidatesTimeliness
  module Extensions
    autoload :DateTimeSelect,         'validates_timeliness/extensions/date_time_select'
    autoload :AttributeAssignment,     'validates_timeliness/extensions/attribute_assignment'
    autoload :MultiparameterAttribute, 'validates_timeliness/extensions/multiparameter_attribute'
  end

  def self.enable_date_time_select_extension!
    ::ActionView::Helpers::Tags::DateSelect.send(:include, ValidatesTimeliness::Extensions::DateTimeSelect)
  end

  def self.enable_multiparameter_extension!
    ::ActiveRecord::Base.send(:include, ValidatesTimeliness::Extensions::AttributeAssignment)
    ::ActiveRecord::AttributeAssignment::MultiparameterAttribute.send(:include, ValidatesTimeliness::Extensions::MultiparameterAttribute)
  end
end
