# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieWorker do
  # date strings
  let(:start_date) { '20180623' }
  let(:start_date2) { '20180323' }
  let(:end_date) { '20180629' }

  let(:invalid_start_date) { 'hello' }
  let(:invalid_end_date) { 'world' }

  context 'Invalid arguments' do
    it 'releaseDts missing' do
      expect{MovieWorker.new.perform(releaseDte: end_date)}.to(
        raise_error ArgumentError
      )
    end
    it 'releaseDte missing' do
      expect{MovieWorker.new.perform(releaseDts: start_date)}.to(
        raise_error ArgumentError
      )
    end
    it 'Invalid argument type or format' do
      expect{MovieWorker.new.perform(
        releaseDts: invalid_start_date,
        releaseDte: invalid_end_date
      )}.to(
        raise_error ArgumentError
      )
    end
    it 'Reversed date arguments order' do
      expect{MovieWorker.new.perform(
        releaseDts: end_date,
        releaseDte: start_date
      )}.to(
        raise_error ArgumentError
      )
    end
  end
  context 'First try' do
    it 'Store every fetched movie' do
      result = MovieWorker.new.perform(
        releaseDts: start_date,
        releaseDte: end_date
      )

      expect(result[:count][:fetched]).to eq(result[:count][:stored])
      expect(result[:count][:duplicated]).to eq(0)
    end
  end

  # Known fact: From start_date to end_date, 6 finction movies are released.
  # Source: KOFA(KMDB) API
  context 'Retry: first try succeeded half-way (3 of 6 movies stored).' do
    # total_count should be accurate(actual)!
    # halfway_count can be fake as long as it's smaller than total_count
    let(:total_count) { 6 }
    let(:halfway_count) { 2 }
    before(:each) do
      MovieWorker.new.perform(
        releaseDts: start_date,
        releaseDte: end_date,
        listCount: halfway_count
      )
    end

    it 'Store 3 remaining movies' do
      result = MovieWorker.new.perform(
        releaseDts: start_date,
        releaseDte: end_date
      )

      expect(result[:count][:fetched]).to eq(total_count)
      expect(result[:count][:duplicated]).to eq(halfway_count)
    end
  end

  # TODO: add tests for using type, listCount arguments.
  # describe 'Fetch and store documentary movies' do
  #   it {expect{}}
  # end
end
