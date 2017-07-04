require 'spec_helper_acceptance'

test_name 'simp_snmp class'

describe 'simp_snmp class' do
  let(:manifest) {
    <<-EOS
      class { 'simp_snmp': }
    EOS
  }

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end


    describe package('simp_snmp') do
      it { is_expected.to be_installed }
    end

    describe service('simp_snmp') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
