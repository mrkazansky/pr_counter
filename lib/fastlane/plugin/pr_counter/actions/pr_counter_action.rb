require 'fastlane/action'
require 'axlsx' 
require_relative '../helper/pr_counter_helper'

module Fastlane
  module Actions
    class PrCounterAction < Action
      def self.run(params)
        UI.message("The pr_counter plugin is working!")
        branch = params[:branch_name]
        branch_name = branch.gsub("/","_")
        response = Actions::GithubApiAction.run(
          server_url: "https://api.github.com",
          api_token: params[:git_token],
          http_method: "GET",
          path: "/search/issues?q=repo:belivetech/#{params[:repo_name]}+base:#{branch}+is:pull-request+is:merged&per_page=100",
        )
        users = response[:json]["items"].map { |item| item["user"]["login"] }.group_by{|h| h}.map{|k,v| [k,v.size]}
        puts users

        p = Axlsx::Package.new
        wb = p.workbook
        
        wb.add_worksheet(name: "#{branch_name}") do |sheet|
          sheet.add_row ["PRs count for #{branch_name}"]
          row = 1
          users.each do |key, size|
            row += 1
            sheet.add_row [key, size]        
          end
        end
        
        p.serialize "fastlane/#{params[:file_name]}.xlsx"
        
      end

      def self.description
        "Count PR for each member"
      end

      def self.authors
        ["Billsp"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Count PR for each member"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :git_token,
            env_name: 'GIT_TOKEN',
            description: 'Github personal token',
            optional: false,
            type: String,
            verify_block: proc do |value|
              UI.user_error!("No token given") unless value and !value.empty?
            end),
          FastlaneCore::ConfigItem.new(key: :repo_name,
                      env_name: 'REPO_NAME',
                      description: 'Repository name',
                      optional: false,
                      type: String,
                      verify_block: proc do |value|
                        UI.user_error!("No repo name given") unless value and !value.empty?
                      end),
          FastlaneCore::ConfigItem.new(key: :branch_name,
                      env_name: 'REPO_NAME',
                      description: 'Branch name',
                      optional: false,
                      type: String,
                      verify_block: proc do |value|
                        UI.user_error!("No branch name given") unless value and !value.empty?
                      end),                                       
          FastlaneCore::ConfigItem.new(key: :file_name,
                        env_name: 'EXPORT_FILE_NAME',
                        description: 'Export file name',
                        optional: false,
                        type: String,
                        verify_block: proc do |value|
                          UI.user_error!("No file name given") unless value and !value.empty?
                        end)
          ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
