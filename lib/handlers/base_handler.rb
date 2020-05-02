class BaseHandler
  attr_reader :name, :handler_config

  def initialize(name, handler_config)
    @name = name
    @handler_config = handler_config
  end
end
