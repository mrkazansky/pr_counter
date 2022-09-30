describe Fastlane::Actions::PrCounterAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The pr_counter plugin is working!")

      Fastlane::Actions::PrCounterAction.run(nil)
    end
  end
end
