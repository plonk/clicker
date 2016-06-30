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
    File.open(@lock_file_path, 'w') do |f|
      f.puts Process.pid
    end
    yield
    return true
  rescue
    return false
  ensure
    FileUtils.rm(@lock_file_path)    
  end

  def locked?
    File.exist?(@lock_file_path)
  end

  def owner
    pid = nil
    File.open(@lock_file_path) do |f|
      pid = f.gets.to_i
    end
    return pid
  rescue
    return nil
  end
end

end
