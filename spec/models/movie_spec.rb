# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  before { @movie = FactoryBot.build(:movie) }
  subject { @movie }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:kmdb_docid) }
  it { is_expected.to respond_to(:director) }
  it { is_expected.to respond_to(:release_date) }
  it { is_expected.to respond_to(:production_year) }
  it { is_expected.to respond_to(:nation) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :kmdb_docid }
  it { is_expected.to validate_presence_of :release_date }

  it { is_expected.to validate_uniqueness_of :kmdb_docid }
  it {
    is_expected.to(
      validate_numericality_of(
        :production_year
      ).is_greater_than_or_equal_to(1896)
    )
  }

  it { is_expected.to have_many(:questions) }

  describe '#questions association' do
    before do
      @movie.save
      3.times { FactoryBot.create :question, movie: @movie }
    end

    it 'destroys the associated questions on self destruct' do
      questions = @movie.questions
      @movie.destroy
      questions.each do |question|
        expect(Question.find(question)).to(
          raise_error ActiveRecord::RecordNotFound
        )
      end
    end
  end
end
