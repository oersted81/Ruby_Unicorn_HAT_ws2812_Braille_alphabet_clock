require_relative 'lib/ruby_clock_cfg'
include Run
include Ws
include Time_now

begin
Ws.splash
Run.every_sec(1) do
  for i in 0..4
  Ws.show(Time_now.parse[i],i)
  end
end
rescue Interrupt, SystemExit
  Ws.show(nil,nil)
end
