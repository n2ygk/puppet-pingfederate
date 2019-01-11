require 'spec_helper'
describe 'pingfederate' do
  context 'with default values for all parameters' do
    it { is_expected.to contain_class('pingfederate') }
  end
end
