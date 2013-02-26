#
require 'matrix'
require 'rubygame'

# Open a window with a drawable area measuring 640x480 pixels
@screen = Rubygame::Screen.open [512, 512]

# Set the title of the window
@screen.title = "Hello Rubygame World!"
# Create a queue to receive events+
#  + events such as "the mouse has moved", "a key has been pressed" and so on
@event_queue = Rubygame::EventQueue.new

# Use new style events so that this software will work with Rubygame 3.0
@event_queue.enable_new_style_events

@display_matrix = Matrix[[10, 0, 0], [0, 10, 0]]
@transform_matrix = Matrix[[@screen.width / 2], [@screen.height / 2]]

def render_lorenz
  x, y, z = 0.01, 0, 0
  dt = 0.0003

  sigma, rho, beta = 10.0, 28.0, 8.0/3

  2220000.times do |n|
    x1 = x + sigma * (y - x) * dt
    y1 = y + (x * rho - y - x * z)  * dt
    z1 = z + (x * y - beta * z) * dt
    x, y, z = x1, y1, z1

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

# Wait for an event
while event = @event_queue.wait

  # Stop this program if the user closes the window
  break if event.is_a? Rubygame::Events::QuitRequested
end
