# TODO: what about production env?
system 'npm install' if Rails.env.development? || Rails.env.test?