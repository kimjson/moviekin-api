require 'rails_helper'

RSpec.describe Movie, type: :model do
  before { @movie = FactoryBot.build(:movie) }
  subject { @movie }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:code) }
  it { is_expected.to respond_to(:director) }
  it { is_expected.to respond_to(:open_year) }
  it { is_expected.to respond_to(:production_year) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :director }
  it { is_expected.to validate_numericality_of(:open_year).is_greater_than_or_equal_to(1896) }
  it { is_expected.to validate_presence_of :open_year }
  it { is_expected.to validate_numericality_of(:production_year).is_greater_than_or_equal_to(1896) }
  it { is_expected.to validate_presence_of :production_year }

  it { is_expected.to have_many(:questions) }

  describe "#questions association" do

    before do
      @movie.save
      3.times { FactoryBot.create :question, movie: @movie }
    end

    it "destroys the associated questions on self destruct" do
      questions = @movie.questions
      @movie.destroy
      questions.each do |question|
        expect(Question.find(question)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
end
