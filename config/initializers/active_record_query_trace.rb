if Rails.env.development?
  ActiveRecordQueryTrace.enabled = true if defined?(ActiveRecordQueryTrace)
end
