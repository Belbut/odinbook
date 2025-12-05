module ApplicationHelper
  def id_param_for(record)
    record_type = record.model_name.param_key
    "#{record_type}_id"
  end
end
