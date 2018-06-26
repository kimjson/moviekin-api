class MovieJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    MovieWorker.perform_async
  end
end
