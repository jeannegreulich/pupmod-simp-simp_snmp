require 'spec_helper'

describe 'simp_snmp' do
  shared_examples_for "a structured module" do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('simp_snmp') }
    it { is_expected.to contain_class('simp_snmp') }
    it { is_expected.to contain_class('simp_snmp::install').that_comes_before('Class[simp_snmp::config]') }
    it { is_expected.to contain_class('simp_snmp::config') }
    it { is_expected.to contain_class('simp_snmp::service').that_subscribes_to('Class[simp_snmp::config]') }

    it { is_expected.to contain_service('simp_snmp') }
    it { is_expected.to contain_package('simp_snmp').with_ensure('present') }
  end


  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "simp_snmp class without any parameters" do
          let(:params) {{ }}
          it_behaves_like "a structured module"
          it { is_expected.to contain_class('simp_snmp').with_trusted_nets(['127.0.0.1/32']) }
        end

        context "simp_snmp class with firewall enabled" do
          let(:params) {{
            :trusted_nets     => ['10.0.2.0/24'],
            :tcp_listen_port => 1234,
            :enable_firewall => true,
          }}
          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('simp_snmp::config::firewall') }

          it { is_expected.to contain_class('simp_snmp::config::firewall').that_comes_before('Class[simp_snmp::service]') }
          it { is_expected.to create_iptables__listen__tcp_stateful('allow_simp_snmp_tcp_connections').with_dports(1234)
          }
        end

        context "simp_snmp class with selinux enabled" do
          let(:params) {{
            :enable_selinux => true,
          }}
          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('simp_snmp::config::selinux') }
          it { is_expected.to contain_class('simp_snmp::config::selinux').that_comes_before('Class[simp_snmp::service]') }
          it { is_expected.to create_notify('FIXME: selinux') }
        end

        context "simp_snmp class with auditing enabled" do
          let(:params) {{
            :enable_auditing => true,
          }}
          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('simp_snmp::config::auditing') }
          it { is_expected.to contain_class('simp_snmp::config::auditing').that_comes_before('Class[simp_snmp::service]') }
          it { is_expected.to create_notify('FIXME: auditing') }
        end

        context "simp_snmp class with logging enabled" do
          let(:params) {{
            :enable_logging => true,
          }}
          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('simp_snmp::config::logging') }
          it { is_expected.to contain_class('simp_snmp::config::logging').that_comes_before('Class[simp_snmp::service]') }
          it { is_expected.to create_notify('FIXME: logging') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'simp_snmp class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('simp_snmp') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
