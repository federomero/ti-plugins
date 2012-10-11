# Ti plugin that outputs worked time in ledger format
# to the file specified by the 'TIMELOG' env variable
#
# Example
#   export TIMELOG=path_to_your.timelog
#   ti Outbox Build amazing stuff
#
# On start, will append to `$TIMELOG` something like:
#   i 2011-12-21 12:32:49 Outbox  Build amazing stuff
#
# On finish, will append to `$TIMELOG` something like:
#   o 2011-12-20 12:35:56


if ENV['TIMELOG']

  def ledger_format time
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  timer = Ti::Timer

  timer.on :finish do
    open(ENV['TIMELOG'], 'a') do |f|
      f.puts "i #{ledger_format(timer.start_time)} #{timer.project}  #{timer.task.split("\n").first}"
      f.puts "o #{ledger_format(timer.end_time)}"
    end
  end
end
