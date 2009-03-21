
# loxate.com
God.watch do |w|
  dir = File.expand_path(File.dirname(__FILE__)) 
  port = 7733
  w.name = "loxate"
  w.interval = 30.seconds
  w.pid_file = File.join(dir, "rack.#{port}.pid")
  w.start = "cd #{dir}; ruby app.rb -p 7733 -e production"
  w.stop    = "kill `cat #{w.pid_file}`"
  w.restart = "kill -s USR2 `cat #{w.pid_file}`"
  w.uid = 'www'
  w.gid = 'www'
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end
