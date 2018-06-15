# frozen_string_literal: true

# TODO: what about production env?
system 'yarn' if Rails.env.development? || Rails.env.test?
