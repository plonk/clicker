module Clicker

require 'fileutils'

class LaunchLock
  attr_reader :lock_file_path

  def initialize(program_name)
    @config_dir = "#{ENV['HOME']}/.config/#{program_name}"
    @lock_file_path = "#{config_dir}/#{program_name}.lock"
    FileUtils.mkdir_p(config_dir)
  end

  def try_lock
    File.open(lock_file_path, 'w') do |f|
      f.puts Process.pid
    end
    return true
  rescue
    return false
  end

  def unlock
    File.open(lock_file_path) do |f|
      pid = f.gets.to_i
      Process.kill("TERM", pid)
    end
    FileUtils.rm(lock_file_path)
    return true
  rescue Errno::ENOENT
    return false
  end

  def locked?
    File.exist?("#{config_dir}/#{program_name}.lock")
  end

  def owner
    pid = nil
    File.open(lock_file_path) do |f|
      pid = f.gets.to_i
    end
    return pid
  rescue
    return nil
  end
end

end
