# Ti plugin that displays reminders 30 minutes via mountain lion notifications
#
# Requires terminal-notifier [https://github.com/alloy/terminal-notifier]
# Installing by running:
# gem install terminal-notifier

begin
  unless `which terminal-notifier`.empty?
    timer = Ti::Timer
    timer.every 30 do
      `terminal-notifier -message "Working #{timer.minutes} minutes on #{timer.project}" -title "Timer"`
    end
  end
rescue LoadError
end
