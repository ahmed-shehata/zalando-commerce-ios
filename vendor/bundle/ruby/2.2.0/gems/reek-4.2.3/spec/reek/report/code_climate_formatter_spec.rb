require_relative '../../spec_helper'
require_lib 'reek/report/code_climate/code_climate_formatter'

RSpec.describe Reek::Report::CodeClimateFormatter, '#render' do
  let(:warning) do
    FactoryGirl.build(:smell_warning,
                      smell_detector: Reek::Smells::UtilityFunction.new,
                      context:        'context foo',
                      message:        'message bar',
                      lines:          [1, 2],
                      source:         'a/ruby/source/file.rb')
  end
  let(:rendered) { Reek::Report::CodeClimateFormatter.new(warning).render }
  let(:json) { JSON.parse rendered.chop }

  it "sets the type as 'issue'" do
    expect(json['type']).to eq 'issue'
  end

  it 'sets the category' do
    expect(json['categories']).to eq ['Complexity']
  end

  it 'constructs a description based on the context and message' do
    expect(json['description']).to eq 'context foo message bar'
  end

  it 'sets a check name based on the smell detector' do
    expect(json['check_name']).to eq 'UtilityFunction'
  end

  it 'sets the location' do
    expect(json['location']).to eq('path' => 'a/ruby/source/file.rb',
                                   'lines' => { 'begin' => 1, 'end' => 2 })
  end

  it 'sets a content based on the smell detector' do
    expect(json['content']['body']).
      to eq "A _Utility Function_ is any instance method that has no dependency on the state of the instance.\n"
  end

  it 'sets remediation points based on the smell detector' do
    expect(json['remediation_points']).to eq 250_000
  end
end
