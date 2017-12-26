class Leafleter
  # consider importing more from http://leaflet-extras.github.io/leaflet-providers/preview/
  # or using this extension
  def self.openstreetmap_copyright_notice
    'data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  end

  def self.get_positron_tile_Layer
    return "L.tileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
        attribution: '#{openstreetmap_copyright_notice}, basemap: &copy; <a href=\"http://cartodb.com/attributions\">CartoDB</a>',
        subdomains: 'abcd',
        maxZoom: 19
    })"
  end

  def self.get_standard_OSM_tile_Layer
    return "L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '#{openstreetmap_copyright_notice}, basemap made by <a href=\"https://github.com/gravitystorm/openstreetmap-carto/\">openstreetmap-carto project</a>',
        subdomains: 'abc',
        maxZoom: 19
    })"
  end

  def self.leaflet_version
    # leaflet files provided by https://cdnjs.com/libraries/leaflet/, see also leaflet_css_file, leaflet_js_file functions
    return "1.2.0"
  end

  def self.leaflet_css_file
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/#{leaflet_version}/leaflet.css"
  end

  def self.leaflet_js_file
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/#{leaflet_version}/leaflet.js"
  end

  def self.get_html_page_prefix(title, lat_centered, lon_centered, zlevel_centered=13, tile_layer = get_standard_OSM_tile_Layer, width_percent = 100, sidebar_content = "", css = nil)
    returned = """
<!DOCTYPE html>
<html>
<head>
  <title>""" + title + """</title>
  <meta charset=\"utf-8\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <link rel=\"stylesheet\" href=\"#{leaflet_css_file}\" />
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

        <script src=\"#{leaflet_js_file}\"></script>
        <script>
          var map = L.map('map').setView([""" + "#{lat_centered}, #{lon_centered}], #{zlevel_centered}" + """);
          mapLink = '<a href=\"http://openstreetmap.org\">OpenStreetMap</a>';
          #{tile_layer}.addTo(map);
"""
    return returned
  end

  def self.get_html_page_suffix
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
    dummy_color = "black"
    return get_polyline([[lat1, lon1], [lat2, lon2]], color, dummy_color, weight, opacity)
  end

  def self.get_polygon(positions, color = 'red', fill_color = 'red', weight = 3, opacity = 0.7)
    return get_polyline(positions, color, weight, opacity)
  end

  def self.get_polyline(positions, color = 'red', fill_color = 'red', weight = 3, opacity = 0.7)
    locations_string = ""
    positions.each do |position|
      locations_string += ", " if locations_string != ""
      locations_string += get_location(position[0], position[1])
    end
    return "    L.polyline([" + locations_string + "]," + " {color: '" + color.to_s + "', fill: '" + fill_color.to_s + "', weight: " + weight.to_s + ", opacity: " + opacity.to_s + ", lineJoin: 'round'}).addTo(map);"""
  end
end
