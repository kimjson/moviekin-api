# frozen_string_literal: true

RSpec.shared_examples 'not found' do |type|
  it 'returns status code 404' do
    expect(response).to have_http_status(404)
  end

  it 'returns a not found message' do
    json_response[:errors].each do |error|
      expect(error[:title]).to match(/^#{type.capitalize} not found$/)
      expect(error[:detail]).to match(/^#{type.capitalize} not found$/)
    end
  end
end

RSpec.shared_examples 'returns 4 records from the database' do |type|
  before(:each) do
    4.times { FactoryBot.create type.to_sym }
    get "/#{type.pluralize}"
  end

  it 'returns 4 records from the database' do
    expect(json_response[:data].size).to eq(4)
  end

  it { expect(response).to have_http_status(200) }
end

RSpec.shared_examples 'field validation error result' do |type|
  it 'renders an errors json' do
    expect(json_response).to have_key(:errors)
  end

  it 'renders the json errors on which field was the problem' do
    json_response[:errors].each do |error|
      expect(error[:source][:pointer]).to match(%r{^/data/attributes/})
      expect(error[:title]).to match(/^Invalid #{type.capitalize}$/)
    end
  end

  it { expect(response).to have_http_status(422) }
end

RSpec.shared_examples 'response attributes correct' do |target_attributes|
  it 'renders the json for the updated record' do
    expect(json_response[:data]).not_to be_empty
    target_attributes.each do |key, value|
      expect(json_response[:data][:attributes][key]).to eql value
    end
  end
end

RSpec.shared_examples 'returns record with correct id' do
  it 'returns the record with correct id' do
    expect(json_response[:data][:id]).to eql target_id
  end
end

RSpec.shared_examples 'response attributes correct v2' do
  it 'renders the json for the updated record' do
    expect(json_response[:data]).not_to be_empty
    target_attributes.each do |key, value|
      expect(json_response[:data][:attributes][key]).to eql value
    end
  end
end

RSpec.shared_examples 'returns status code 200' do
  it { expect(response).to have_http_status(200) }
end
