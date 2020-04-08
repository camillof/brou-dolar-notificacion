class BaseHandler
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # def call(job, time)
  #   raise NotImplementedError, "subclass did not define #call"
  # end

end
