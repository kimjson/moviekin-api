# frozen_string_literal: true

desc 'Fetch movies from KOFA api and save them on db'
task movie_task: :environment do
  start_date = Date.today.prev_day(7).strftime('%Y%m%d')
  end_date = Date.today.strftime('%Y%m%d')

  # Fetch and store fiction movies released last week
  MovieWorker.perform_async(start_date: start_date, end_date: end_date)

  # Fetch and store documentary movies released last week
  MovieWorker.perform_async(
    start_date: start_date,
    end_date: end_date,
    type: '다큐멘터리'
  )

  # TODO: Fetch and store old movies. This should not be in cron job.
end
