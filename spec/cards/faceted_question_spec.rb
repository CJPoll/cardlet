require 'spec_helper'

describe Cardlet::Cards::FacetedQuestion do
  let(:hash) {{
    'prompt' => 'What is your name?',
    'facets' => [
      'Cody',
      'Poll'
    ]
  }}
  subject { Cardlet::Cards::FacetedQuestion.new(hash) }

  it 'generates a uuid if none in hash' do
    expect(subject.uuid).to match /[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/
  end

  it 'uses the passed in uuid if given' do
    hash['uuid'] = :uuid
    expect(subject.uuid).to eq :uuid
  end

  it 'has a prompt' do
    expect(subject).to respond_to :prompt
  end

  it 'has facets' do
    expect(subject).to respond_to :facets
  end

  it 'can have many facets' do
    expect(subject.facets).to be_an(Array)
  end

  it 'knows when a response matches the facets' do
    response = ['Cody', 'Poll']
    expect(subject.correct?(response)).to be true
  end

  it 'does not match if the order is wrong' do
    response = ['Poll', 'Cody']
    expect(subject.correct?(response)).to be false
  end

  it 'can add a tag' do
    subject.add_tag('hello')
    expect(subject.tags).to eq ['hello']
  end
end
