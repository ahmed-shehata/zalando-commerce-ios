When /^I run reek (.*)$/ do |args|
  reek(args)
end

When /^I pass "([^\"]*)" to reek *(.*)$/ do |stdin, args|
  reek_with_pipe(stdin, args)
end

When /^I run rake (\w*) with:$/ do |name, task_def|
  rake(name, task_def)
end

Then /^it reports nothing$/ do
  expect(last_command_started).to have_output_on_stdout('')
end

Then /^there is no output on stdout$/ do
  expect(last_command_started).to have_output_on_stdout('')
end

Then /^stdout includes "(.*)"$/ do |text|
  expect(last_command_started).to have_output_on_stdout(/#{Regexp.escape(text)}/)
end

Then /^it succeeds$/ do
  success = Reek::CLI::Options::DEFAULT_SUCCESS_EXIT_CODE
  expect(last_command_started).to have_exit_status(success)
end

Then /^the exit status indicates an error$/ do
  error = Reek::CLI::Options::DEFAULT_ERROR_EXIT_CODE
  expect(last_command_started).to have_exit_status(error)
end

Then /^the exit status indicates smells$/ do
  smells = Reek::CLI::Options::DEFAULT_FAILURE_EXIT_CODE
  expect(last_command_started).to have_exit_status(smells)
end

Then(/^the exit status is (\d+)$/) do |status|
  expect(last_command_started).to have_exit_status(status.to_i)
end

Then /^it reports:$/ do |report|
  expect(last_command_started).to have_output_on_stdout(report.gsub('\n', "\n"))
end

Then /^it reports this yaml:$/ do |expected_yaml|
  expected_warnings = YAML.load(expected_yaml.chomp)
  actual_warnings = YAML.load(last_command_started.stdout)
  expect(actual_warnings).to eq expected_warnings
end

Then /^it reports this JSON:$/ do |expected_json|
  expected_warnings = JSON.parse(expected_json.chomp)
  actual_warnings = JSON.parse(last_command_started.stdout)
  expect(actual_warnings).to eq expected_warnings
end

Then /^stderr reports:$/ do |report|
  expect(last_command_started).to have_output_on_stderr(report.chomp)
end

Then /^it reports no errors$/ do
  expect(last_command_started).to have_output_on_stderr('')
end

Then /^it reports an error$/ do
  expect(last_command_started.stderr).to_not be_empty
end

Then /^it reports the error ['"](.*)['"]$/ do |string|
  expect(last_command_started).to have_output_on_stderr(/#{Regexp.escape(string)}/)
end

Then /^it reports a parsing error$/ do
  expect(last_command_started).to have_output_on_stderr(/Parser::SyntaxError/)
end

Then /^it should indicate the line numbers of those smells$/ do
  expect(last_command_started).to have_output(/\[.*\]:/)
end

Then /^it reports the current version$/ do
  expect(last_command_started).to have_output("reek #{Reek::Version::STRING}")
end
