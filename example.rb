require 'leafleter'

File.open('output.html', 'w') do |out|
  out.puts Leafleter.get_html_page_prefix("website title", 50.06, 19.93)
  out.puts Leafleter.get_marker("text", 50.06, 19.93)
  out.puts Leafleter.get_marker("text2", 50.06, 19.94)
  out.puts Leafleter.get_marker("text3", 50.06, 19.95)
  out.puts Leafleter.get_circle_marker("circle", 50.07, 19.94, radius_in_px = 10)
  out.puts Leafleter.get_circle_marker("circle", 50.07, 19.96, radius_in_px = 10, options = {"color": '"red"'})
  out.puts Leafleter.get_line(50.06, 19.92, 170, 0, color = 'blue')
  shape = [[50.06, 19.93], [50.05, 19.80], [50.02, 19.83], [50.06, 19.93]]
  out.puts Leafleter.get_polygon(shape, color = "green", fill_color = "green")
  out.puts Leafleter.get_html_page_suffix
end
