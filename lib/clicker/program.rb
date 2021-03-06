require_relative 'sound'
require 'optparse'

module Clicker

class Program
  def initialize
    @mode = :normal
    OptionParser.new do |opt|
      opt.on('--start', 'start as a daemon') { @mode = :start}
      opt.on('--stop', 'stop the daemon') { @mode = :stop }
      opt.on('-v', '--version', 'print version information and exit') { print_version; exit 0 }
      opt.parse!(ARGV)
    end

    @lock = LaunchLock.new('clicker')
  end

  def print_version
    STDERR.puts "clicker #{Clicker::VERSION}"
    STDERR.puts "Copyright © 2016 Yoteichi"
  end

  def run
    case @mode
    when :normal
      success = @lock.try_lock do
        do_run
      end

      unless success
        STDERR.puts("Error: another instance of clicker is running. (PID #{@lock.owner})")
        exit 1
      end
    when :start
      if @lock.locked?
        STDERR.puts("Error: another instance of clicker is running. (PID #{@lock.owner})")
        exit 1
      else
        if fork == nil
          if fork == nil
            @lock.try_lock do
              do_run
            end
            # ここでは端末から切り離されているのでロックに失敗しても出来ることはない。
          end
        end
      end
    when :stop
      if @lock.locked?
        owner = @lock.owner
        begin
          Process.kill("TERM", owner)
          STDERR.puts("SIGTERM has been sent to PID #{owner}.")
        rescue Errno::ESRCH
          STDERR.puts("Warning: Process (#{owner}) not found.")
        end
      else
        STDERR.puts("no instance is running.")
      end
    end
  end

  def do_run
    model = KeyboardSoundModel.new
    begin
      io = IO.popen("evtest /dev/input/by-path/platform-i8042-serio-0-event-kbd", 'r')
    rescue Errno::ENOENT
      raise 'evtest command not found.'
    end

    loop do
      IO.select([io], [], [])

      line = io.gets
      if line == nil
        break
      elsif line =~ /^Event: time \d+\.\d+, type 1 \(EV_KEY\), code (\d+) \(KEY_.*?\), value (\d+)$/
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
  rescue RuntimeError => e
    STDERR.puts "Error: #{e.to_s}"
    exit 1
  rescue Interrupt
  end
end

if __FILE__ == $0
  Program.new.run
end

end
