#
require "rubygame"

# Open a window with a drawable area measuring 640x480 pixels
@screen = Rubygame::Screen.open [512, 512]

# Set the title of the window
@screen.title = "Hello Rubygame World!"
# Create a queue to receive events+
#  + events such as "the mouse has moved", "a key has been pressed" and so on
@event_queue = Rubygame::EventQueue.new

# Use new style events so that this software will work with Rubygame 3.0
@event_queue.enable_new_style_events

def render_lorenz
  display_matrix = [[30, 0, 0], [0, 30, 0], [0, 0, 0]]
  transform_matrix = [@screen.width / 2, @screen.height / 2]
  x, y, z = 3.051522, 1.582542, 15.62388
  dt = 0.0001

  sigma, rho, beta = 13, 10, 8.0/3

  200000.times do
    x1 = x + sigma * (y - x) * dt
    y1 = y + (rho * x - x * z - y) * dt
    z1 = z + (x * y - beta * z) * dt
    x, y, z = x1, y1, z1

#    p [x, y, z]

    disp_x = disp_y = nil
    display_matrix.tap { |m|
      disp_x = m[0][0] * x + m[0][1] * y + m[0][2] * z
      disp_y = m[1][0] * x + m[1][1] * y + m[1][2] * z
      disp_x += transform_matrix[0]
      disp_y += transform_matrix[0]
    }
    @screen.set_at([disp_x, disp_y], [255, 255, 0]) rescue IndexError

  end
  @screen.update
end

render_lorenz

# Wait for an event
while event = @event_queue.wait

  # Stop this program if the user closes the window
  break if event.is_a? Rubygame::Events::QuitRequested
end
