require 'rails_helper'

describe Answer do
  let(:answer) { FactoryBot.build :answer }
  subject { answer }

  it { should respond_to(:content) }
  it { should respond_to(:question_id) }

  it { should validate_presence_of :content }
  it { should validate_presence_of :question_id }

  it { should belong_to :question }
end