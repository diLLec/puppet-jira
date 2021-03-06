require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::sso' do
    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'default params' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '8.13.5',
                enable_sso: true
              }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/classes/seraph-config.xml') }
            it { is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/classes/crowd.properties') }
          end
          context 'with param application_name set to appname' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '8.13.5',
                enable_sso: true,
                application_name: 'appname'
              }
            end

            it do
              is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/classes/crowd.properties').
                with_content(%r{application.name                        appname})
            end
          end
          context 'with non default params' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '8.13.5',
                enable_sso: true,
                application_name: 'app',
                application_password: 'password',
                application_login_url: 'https://login.url/',
                crowd_server_url: 'https://crowd.url/',
                crowd_base_url: 'http://crowdbase.url'
              }
            end

            it { is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/classes/seraph-config.xml') }
            it do
              is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.13.5-standalone/atlassian-jira/WEB-INF/classes/crowd.properties').
                with_content(%r{application.name                        app}).
                with_content(%r{application.password                    password}).
                with_content(%r{application.login.url                   https://login.url/}).
                with_content(%r{crowd.server.url                        https://crowd.url/}).
                with_content(%r{crowd.base.url                          http://crowdbase.url})
            end
          end
        end
      end
    end
  end
end
