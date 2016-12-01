require 'spec_helper'
describe 'pingfederate' do

  context 'with default values for all parameters' do
    it { should contain_class('pingfederate') }
  end
end
