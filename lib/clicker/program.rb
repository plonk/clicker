require_relative 'sound'

class Program
  def initialize
  end

  def run
    model = KeyboardSoundModel.new
    io = IO.popen("evtest /dev/input/by-path/platform-i8042-serio-0-event-kbd", 'r')
    loop do
      IO.select([io], [], [])

      line = io.gets
      if line =~ /^Event: time \d+\.\d+, type 1 \(EV_KEY\), code (\d+) \(KEY_.*?\), value (\d+)$/
        code, value = $1.to_i, $2.to_i

        case value
        when 0
          model.deactivate_key(code)
        when 1
          model.activate_key(code)
        when 2
          model.repeat_key(code)
        end
      end
      model.update
    end
  end
end

if __FILE__ == $0
  Program.new.run
end
