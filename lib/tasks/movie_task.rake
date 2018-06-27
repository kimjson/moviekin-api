# frozen_string_literal: true

desc 'Fetch movies from KOFA api and save them on db'
task movie_task: :environment do
  MovieWorker.perform_async
end
