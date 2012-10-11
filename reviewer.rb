# Ti plugin to review time entries before finishing
#
# Opens the system's editor (defaults to vim if $EDITOR is not defined)
# and allows you to make changes to the time entry at once the timer is finished
#

timer = Ti::Timer

timer.on :finish, 0 do
  file =`mktemp /tmp/ti.XXXXXXXX`.chomp

  attrs = [:project, :start_time, :end_time]
  open(file, 'w') do |f|
    f.puts timer.task
    f.puts "\n---\n\n"
    pad = attrs.map(&:length).max + 1
    attrs.each do |attr|
      f.puts "#{attr}:".ljust(pad) + " #{timer.send(attr)}"
    end
  end

  system("#{ENV['EDITOR'] || 'vim'} #{file}")

  content = open(file, 'r').read

  task, data = content.split(/\n\n?---\n\n?/)
  timer.task = task
  attrs.each do |attr|
    if m = data.match(/^#{attr}:\s*(.*)$/)
      timer.send("#{attr}=", m[1])
    end
  end

  `rm #{file}`

end
