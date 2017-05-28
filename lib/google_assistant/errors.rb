module GoogleAssistant
  InvalidIntent = Class.new(StandardError)
  InvalidMessage = Class.new(StandardError)
  InvalidInputPrompt = Class.new(StandardError)
  InvalidPermission = Class.new(StandardError)
  InvalidPermissionContext = Class.new(StandardError)
  MissingRequestInputs = Class.new(StandardError)
  MissingRequestIntent = Class.new(StandardError)
end
