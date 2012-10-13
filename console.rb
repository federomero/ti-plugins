begin
  require 'rainbow'
rescue LoadError
  class String
    def color arg
      self
    end
  end
end

timer = Ti::Timer

timer.every 1 do
  msg = "Working for #{timer.minutes.to_s.rjust(3).color(:red)} minutes"
  msg += " on #{timer.project.color(:green)}"
  msg += " - #{timer.task.color(:green)}" unless timer.task.empty?
  puts msg
end

timer.on :finish do
  puts "Done with #{timer.project.color(:green)}"
end
