RSpec.configure do |config|
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Lint factories (ensure they're valid)
  config.before(:suite) do
    FactoryBot.lint unless ENV['SKIP_FACTORY_LINT']
  end
end