#

require 'rubygame'
require_relative 'lorenz'

class Game
  def initialize
    @screen = Rubygame::Screen.new([512, 512], 0,
                                   [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @screen.title = "Lorenz!"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 100

    @lorenz_system = LorenzSystem.new(10.0, 28.0, 8.0/3.0)
    @practicle = LorenzPracticle.new(0.001, 0.0, 0.0, @lorenz_system, 0.001)
    @camera = Projector.new(Matrix[[10, 0, 0], [0, 10, 0]],
                            Matrix[[@screen.width / 2], [@screen.height / 2]])
  end

  def run
    loop do
      update
      draw
      #      @clock.tick
    end
  end

  def update
    @queue.each do |ev|
      case ev
      when Rubygame::QuitEvent
        Rubygame.quit
        exit
      end
    end
  end

  def draw
    x, y = @practicle.project(@camera)
    @practicle.step!

    @screen.set_at([x, y], [255, 255, 0]) rescue IndexError
    @screen.flip
  end
end

game = Game.new
game.run
