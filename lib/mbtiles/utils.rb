module MBTiles
  module Utils
    module_function

    def coords2tile(lat, lon, zoom)
      n = 2 ** zoom
      lat_rad = lat / 180 * Math::PI

      x = ((lon + 180) / 360 * n)
      y = (1 - Math.log(Math.tan(lat_rad) + (1 / Math.cos(lat_rad))) / Math::PI) / 2 * n

      [x, y].map(&:to_i)
    end

    def tile2coords(x, y, zoom)
      n = 2.0 ** zoom

      lon = x / n * 360.0 - 180.0
      lat_rad = Math.atan(Math.sinh(Math::PI * (1.0 - 2.0 * y / n)))
      lat = lat_rad * 180 / Math::PI

      [lat, lon].map { |c| c.round(5) }
    end

    def valid_image?(blob)
      blob.start_with?("\x89PNG".force_encoding('ASCII-8BIT'))
    end
  end
end
