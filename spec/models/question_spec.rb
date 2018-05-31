require 'rails_helper'

describe Question do
  before { @question = FactoryBot.build(:question) }
  subject { @question }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:movie_id) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_presence_of :movie_id }

  it { is_expected.to belong_to :movie }
  it { is_expected.to have_many(:answers) }

  describe "#answers association" do

    before do
      @question.save
      3.times { FactoryBot.create :answer, question: @question }
    end

    it "destroys the associated answers on self destruct" do
      answers = @question.answers
      @question.destroy
      answers.each do |answer|
        expect(Answer.find(answer)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end