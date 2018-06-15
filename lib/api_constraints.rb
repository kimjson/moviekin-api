# frozen_string_literal: true

# set many-one relationship betweeen question and movie
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?(
      "application/vnd.moviekin.v#{@version}"
    )
  end
end
