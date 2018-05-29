require 'rails_helper'

describe Answer do
  let(:answer) { FactoryBot.build :answer }
  subject { answer }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:question_id) }

  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_presence_of :question_id }

  it { is_expected.to belong_to :question }
end