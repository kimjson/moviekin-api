# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieWorker do
  # date strings
  let(:start_date) { '20180623' }
  let(:start_date2) { '20180609' }
  let(:end_date) { '20180629' }

  let(:invalid_start_date) { 'hello' }
  let(:invalid_end_date) { 'world' }

  context 'Invalid arguments' do
    it 'start_date missing' do
      expect { MovieWorker.new.perform(end_date: end_date) }.to(
        raise_error ArgumentError
      )
    end
    it 'end_date missing' do
      expect { MovieWorker.new.perform(start_date: start_date) }.to(
        raise_error ArgumentError
      )
    end
    it 'Invalid argument type or format' do
      expect do
        MovieWorker.new.perform(
          start_date: invalid_start_date,
          end_date: invalid_end_date
        )
      end .to(
        raise_error ArgumentError
      )
    end
    it 'Reversed date arguments order' do
      expect do
        MovieWorker.new.perform(
          start_date: end_date,
          end_date: start_date
        )
      end .to(
        raise_error ArgumentError
      )
    end
  end
  context 'First try' do
    it 'Store every fetched movie' do
      result = MovieWorker.new.perform(
        start_date: start_date,
        end_date: end_date
      )

      expect(result[:count][:fetched]).to eq(result[:count][:stored])
      expect(result[:count][:duplicated]).to eq(0)
    end
  end

  # Known fact: From start_date to end_date, 6 finction movies are released.
  # Source: KOFA(KMDB) API
  context 'Retry: first try succeeded half-way (2 of movies stored).' do
    # total_count should be accurate(actual)!
    # halfway_count can be fake as long as it's smaller than total_count
    before(:each) do
      Movie.destroy_all
      @halfway_count = 2
      movies = MovieWorker.new.perform(
        start_date: start_date,
        end_date: end_date
      )[:data]
      @total_count = movies.length
      movies.each(&:destroy)
      MovieWorker.new.perform(
        start_date: start_date,
        end_date: end_date,
        list_count: @halfway_count
      )
    end

    it 'Store remaining movies' do
      result = MovieWorker.new.perform(
        start_date: start_date,
        end_date: end_date
      )

      expect(result[:count][:fetched]).to eq(@total_count)
      expect(result[:count][:duplicated]).to eq(@halfway_count)
    end
  end

  describe 'Fetch and store documentary movies' do
    let(:total_count) { 2 }
    it do
      result = MovieWorker.new.perform(
        start_date: start_date2,
        end_date: end_date,
        type: '다큐멘터리'
      )
      movies = result[:data]
      expect(result[:count][:fetched]).to eq(movies.length)
      expect(result[:count][:stored]).to eq(movies.length)
      expect(result[:count][:duplicated]).to eq(0)
    end
  end

  describe 'Fetch and store some of the movies' do
    let(:list_count) { 2 }
    it do
      result = MovieWorker.new.perform(
        start_date: start_date,
        end_date: end_date,
        list_count: list_count
      )
      expect(result[:count][:fetched]).to eq(list_count)
      expect(result[:count][:stored]).to eq(list_count)
      expect(result[:count][:duplicated]).to eq(0)
    end
  end
end
