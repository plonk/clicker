module Clicker

require 'fileutils'

class LaunchLock
  attr_reader :lock_file_path

  def initialize(program_name)
    @config_dir = "#{ENV['HOME']}/.config/#{program_name}"
    @lock_file_path = "#{@config_dir}/#{program_name}.lock"
    FileUtils.mkdir_p(@config_dir)
  end

  def try_lock
    File.open(@lock_file_path, 'r+') do |f|
      success = f.flock(File::LOCK_EX | File::LOCK_NB)
      if success
        f.puts Process.pid
        f.flush
	f.truncate(f.pos)
        yield
        return true
      else
        return false
      end
    end
  end

  def locked?
    File.open(@lock_file_path, 'r') do |f|
      rv =  f.flock(File::LOCK_EX | File::LOCK_NB)
      case rv
      when 0
	return false
      when false
	return true
      end
    end
  rescue Errno::ENOENT
    return false
  end

  def owner
    File.open(@lock_file_path) do |f|
      success = f.flock(File::LOCK_EX | File::LOCK_NB)
      if success
        return nil # owner is not alive...
      else
        pid = f.gets.to_i
        return pid
      end
    end
  rescue Errno::ENOENT
    return nil
  end
end

end
