require 'sdl'

module Clicker

class KeyboardSoundModel
  include SDL
  
  ACTIVATE = 0
  DEACTIVATE = 1
  
  def initialize
    init(INIT_AUDIO)

    begin
      SDL::Mixer
    rescue NameError
      raise "SDL::Mixer class not found. Make sure the rubysdl gem is built with sdl mixer."
    end

    # バッファー長 128 くらいでも動作するが、pulseaudio のCPU負荷が高
    # くなるのであまり調子にのらないほうがいい。
    Mixer.open(44100, Mixer::DEFAULT_FORMAT, 2, 1024)

    @sounds = [nil, nil]
    @sounds[ACTIVATE] = Mixer::Wave.load(File.dirname(__FILE__) + '/ibm_on.wav')
    @sounds[DEACTIVATE] = Mixer::Wave.load(File.dirname(__FILE__) + '/ibm_off.wav')
    @counts = [0, 0]
    Mixer.allocate_channels(12)
  end

  def activate_key(code)
    @counts[ACTIVATE] += 1
  end

  def deactivate_key(code)
    @counts[DEACTIVATE] += 1
  end

  def repeat_key(code)
  end

  def update
    # p Mixer.playing_channels
    [ACTIVATE, DEACTIVATE].each do |kind|
      @counts[kind].times do 
	begin
          Mixer.play_channel(-1, @sounds[kind], 0)
	rescue SDL::Error
	end
        sleep(0.0027)
      end
    end
    @counts[0] = @counts[1] = 0
  end
end

end
