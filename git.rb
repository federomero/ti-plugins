# Ti plugin that adds git commit messages to the task description
# from the commits created during the period
#
# If the repo is hosted at github, it also add a compare link
# to review all work done during the period
#

if !`which git`.empty? && system('git status &> /dev/null')
  timer = Ti::Timer
  timer.on :finish, -1 do
    user = `git config user.name`.chomp
    cmd = "git log --author='#{user}' --pretty=oneline --since='#{timer.start_time}' --until='#{timer.end_time}' --no-merges"
    commits = `#{cmd}`
    unless commits.empty?
      timer.task += "\n\nCommits:\n\n" + commits

      github_url = `git remote -v | grep github -m 1 | awk '{print $2}'`.chomp
      unless github_url.empty?
        if m = github_url.match(/(?::|\/)([^\/]+)\/([^\/]+).git$/)
          github_user = m[1]
          github_project = m[2]
          shas = [commits.split("\n").last, commits.split("\n").first].map{|a| a.split(' ').first}
          compare_url = "https://github.com/#{github_user}/#{github_project}/compare/#{shas.join('...')}"
          timer.task += "\nCompare at github: #{compare_url}\n"
        end
      end
    end
  end
end
