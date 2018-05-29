require 'rails_helper'

RSpec.describe Movie, type: :model do
  before { @movie = FactoryBot.build(:movie) }
  subject { @movie }

  it { should respond_to(:name) }
  it { should respond_to(:code) }
  it { should respond_to(:director) }
  it { should respond_to(:open_year) }
  it { should respond_to(:production_year) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should validate_presence_of :director }
  it { should validate_numericality_of(:open_year).is_greater_than_or_equal_to(1896) }
  it { should validate_presence_of :open_year }
  it { should validate_numericality_of(:production_year).is_greater_than_or_equal_to(1896) }
  it { should validate_presence_of :production_year }
  
end
