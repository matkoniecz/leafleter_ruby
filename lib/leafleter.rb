class Leafleter
  # consider importing more from http://leaflet-extras.github.io/leaflet-providers/preview/
  # or using this extension
  def self.get_positron_tile_Layer
    return "L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href=\"http://www.openstreetmap.org/copyright\">OpenStreetMap</a> &copy; <a href=\"http://cartodb.com/attributions\">CartoDB</a>',
        subdomains: 'abcd',
        maxZoom: 19
    })"
  end

  def self.get_standard_OSM_tile_Layer
    return "L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href=\"http://www.openstreetmap.org/copyright\">OpenStreetMap</a>'
})"
  end

  def self.get_before(title, lat_centered, lon_centered, zlevel_centered, tile_layer = get_standard_OSM_tile_Layer, width_percent = 100, sidebar_content = "", css = nil)
    returned = """
<!DOCTYPE html>
<html>
<head>
	<title>""" + title + """</title>
	<meta charset=\"utf-8\" />
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
	<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.css\" />
"""
    unless css.nil?
      returned += '<link rel="stylesheet" type="text/css" href="' + css + '" />'
    end
    returned += """<style>
        body {
            padding: 0;
            margin: 0;
        }
        html, body {
            height: 100%;
            width: 100%;
        }
        #map {
            height: 100%;
            width: #{width_percent}%;
            float: left;
        }"""
    if width_percent != 100
      returned += """
  #pane {
      height: 100%;
      width: #{100 - width_percent}%;
      float: right;
  }"""
        end
    returned +=
      """    </style>
      </head>
      <body>
      	<div id=\"map\"></div><div id=\"pane\">#{sidebar_content}</div>

      	<script src=\"https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.js\"></script>
      	<script>
      		var map = L.map('map').setView([""" + "#{lat_centered}, #{lon_centered}], #{zlevel_centered}" + """);
      		mapLink = '<a href=\"http://openstreetmap.org\">OpenStreetMap</a>';
      		#{tile_layer}.addTo(map);
      """
    return returned
  end

  def self.get_after
    return """
</script>
</body>
</html>
"""
  end

  def self.get_location(lat, lon)
    return "[" + lat.to_s + ", " + lon.to_s + "]"
  end

  def self.get_marker(text, lat, lon)
    location = get_location(lat, lon)
    return "L.marker(" + location + ").addTo(map).bindPopup(\"" + text + ".\");\n"
  end

  def self.get_circle_marker(text, lat, lon, radius = 10, options = {})
    location = get_location(lat, lon)
    option_string = ""
    if options != {}
      option_string = ", {"
      for pair in options
        option_string += "\t#{pair[0]}: #{pair[1]},"
      end
      option_string += "\n}"
    end
    return "L.circleMarker(" + location + option_string + ").setRadius(#{radius}).addTo(map).bindPopup(\"" + text + ".\");\n"
  end

  def self.get_line(lat1, lon1, lat2, lon2, color = 'red', weight = 3, opacity = 0.7)
    location1 = get_location(lat1, lon1)
    location2 = get_location(lat2, lon2)
    return "L.polyline([" + location1 + ", " + location2 + "]," + """
    {
              color: '""" + color.to_s + """',
              weight: """ + weight.to_s + """,
              opacity: """ + opacity.to_s + """,
              lineJoin: 'round'
          }
          ).addTo(map);"""
  end
end
