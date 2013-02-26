#

require 'matrix'

class LorenzSystem
  #  sigma, rho, beta = 10.0, 28.0, 8.0/3
  attr_accessor :sigma, :rho, :beta
  def initialize(sigma, rho, beta)
    @sigma = sigma
    @rho = rho
    @beta = beta
  end

  def get_vector(x, y, z)
    dx = @sigma * (y - x)
    dy = x * (@rho - z) - y
    dz = x * y - @beta * z
    [dx, dy, dz]
  end
end

class LorenzPracticle
  attr_accessor :x, :y, :z, :system, :delta
  def initialize(x, y, z, lorenz_system, delta)
    @system = lorenz_system
    @x, @y, @z = x, y, z
    @delta = delta
  end

  def project(projector)
    projector.project_2d(@x, @y, @z)
  end

  def step!
    dx, dy, dz = @system.get_vector(@x, @y, @z)
    @x += dx * @delta
    @y += dy * @delta
    @z += dz * @delta
  end
end

class Projector
  # @display_matrix = Matrix[[10, 0, 0], [0, 10, 0]]
  # @transform_matrix = Matrix[[@screen.width / 2], [@screen.height / 2]]
  attr_accessor :proj_matrix, :trans_matrix
  def initialize(proj_matrix, trans_matrix)
    @proj_matrix = proj_matrix
    @trans_matrix = trans_matrix
  end

  def project_2d(x, y, z)
    coords = Matrix[[x, y, z]].transpose
    coord_vector = (@proj_matrix * coords) + @trans_matrix
    [coord_vector[0, 0], coord_vector[1, 0]]
  end
end
=begin
def render_lorenz
  x, y, z = 200, 0, 0
  #  dt = 0.0003

  100000.times do |n|

    disp_x = disp_y = nil
    @display_matrix.tap { |m|
      coords = Matrix[[x, y, z]].transpose
      coord_vector = (m * coords) + @transform_matrix
      disp_x, disp_y = coord_vector[0, 0], coord_vector[1, 0]
    }
    @screen.set_at([disp_x, disp_y], [255, 255, 0]) rescue IndexError
    @screen.update if n % 1000 == 0
  end
  @screen.update
end

render_lorenz

=end
