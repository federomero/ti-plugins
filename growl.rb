# Ti plugin that displays reminders every 30 minutes via growl

begin
  require 'growl'
  if Growl.installed?
    timer = Ti::Timer
    timer.every 30 do
      Growl.notify_info timer.task, title: "Working #{timer.minutes} minutes on #{timer.project}"
    end
  end
rescue LoadError
end
