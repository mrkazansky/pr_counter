require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class PrCounterHelper
      # class methods that you define here become available in your action
      # as `Helper::PrCounterHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the pr_counter plugin helper!")
      end
    end
  end
end
