require 'rails_helper'

describe Question do
  let(:question) { FactoryBot.build :question }
  subject { question }

  it { should respond_to(:title) }
  it { should respond_to(:content) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
end