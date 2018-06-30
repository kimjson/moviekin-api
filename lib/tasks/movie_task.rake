# frozen_string_literal: true

desc 'Fetch movies from KOFA api and save them on db'
task movie_task: :environment do
  releaseDts = Date.today.prev_day(7).strftime('%Y%m%d')
  releaseDte =  Date.today.strftime('%Y%m%d')

  # Fetch and store fiction movies released last week
  MovieWorker.perform_async(releaseDts: releaseDts, releaseDte: releaseDte)

  # Fetch and store documentary movies released last week
  MovieWorker.perform_async(
    releaseDts: releaseDts,
    releaseDte: releaseDte,
    type: '다큐멘터리'
  )

  # TODO: Fetch and store old movies. This should not be in cron job.
end
