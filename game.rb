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

    @lorenz_system = LorenzSystem.new(10.0, 15, 8.0/3.0)
    #    @camera = Projector.new(Matrix[[10, 0, 0], [0, 10, 0]],
    @camera = Projector.new(Matrix[[10, 10, -5], [5, 15, 5]],
                            Matrix[[@screen.width / 2], [@screen.height / 2]])
    @practicles = [LorenzPracticle.new(0.001, 0.0, 0.0,
                                       @lorenz_system, 0.001)]
  end

  def run
    10000.times { @practicles.push(@practicles[-1].step) }
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
      when Rubygame::MouseDownEvent
        @mouse_hold = true if ev.button & 1
        @mouse_hold_pos = ev.pos
        @origin_camera_trans_matrix = @camera.trans_matrix
#        @origin_camera_proj_matrix = @camera.proj_matrix
      when Rubygame::MouseUpEvent
        @mouse_hold = false if ev.button & 1
        @mouse_hold_pos = nil
      when Rubygame::MouseMotionEvent
        next unless @mouse_hold
        @camera.trans_matrix = @origin_camera_trans_matrix
#        @camera.proj_matrix = @origin_camera_proj_matrix
        dx = ev.pos[0] - @mouse_hold_pos[0]
        dy = ev.pos[1] - @mouse_hold_pos[1]
        @camera.translate(dx, dy)
#        @camera.rotate(dx * (2*3.14/200), dy * (2*3.14/200), 0)
      end
    end
  end

  def draw
    @screen.fill([0, 0, 0])
    @practicles.map {|x| x.project(@camera) }.each do |x, y|
      @screen.set_at([x, y], [255, 255, 0]) rescue IndexError
    end

    @screen.flip
  end
end

game = Game.new
game.run
