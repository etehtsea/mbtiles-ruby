require 'digest/md5'
require 'mbtiles/utils'
require 'mbtiles/database'

# y, x == lat, lon == row, col

module MBTiles
  class InvalidImage < Exception; end

  class TileBox
    require 'net/http'

    def initialize(url)
      @url = url
    end

    def get(zoom, column, row)
      url = [@url, zoom, column, row].join('/') << '.png'
      puts url

      Net::HTTP.get(URI.parse(url))
    end
  end

  class Writer
    include Utils

    ADJUSTMENT = 1.0003

    def initialize(coords, fetcher, path = nil)
      @coords = coords
      @mbtiles = Database.new(path)
      @min_zoom, @max_zoom = [0, 16]
      @fetcher = fetcher
    end

    def tile_blob(zoom, column, row)
      blob = @fetcher.get(zoom, column, row)

      if valid_image?(blob)
        blob
      else
        raise InvalidImage.new([zoom, column, row].join('/'))
      end
    end

    def center
      lat = ((@coords[0] + @coords[2]) / 2.0).round(6)
      lng = ((@coords[1] + @coords[3]) / 2.0).round(6)
      zoom = (@min_zoom + @max_zoom) / 2

      [lng, lat, zoom]
    end

    def bounds
      sw = [@coords[1], @coords[2]]
      ne = [@coords[3], @coords[0]]

      (sw + ne).map { |c| c.round(6) }
    end

    def write_metadata!
      metadata = [
        { 'bounds'  => bounds.join(',') },
        { 'center'  => center.join(',') },
        { 'minzoom' => @min_zoom },
        { 'maxzoom' => @max_zoom },
        { 'type'    => 'baselayer' },
        { 'name'    => 'name' },
        { 'version' => '1.0.0' },
        { 'format'  => 'png' },
        { 'description' => 'description' }
      ]

      @mbtiles.import_metadata(metadata.flat_map(&:to_a))
    end

    def save
      write_metadata!

      values = []
      images = {}

      (@min_zoom..@max_zoom).each do |zoom|
        min_xy = coords2tile(*@coords.first(2), zoom)
        max_xy = coords2tile(*@coords.last(2), zoom)

        first_column, first_row = min_xy.map { |axis| (axis / ADJUSTMENT).to_i }
        last_column, last_row = max_xy.map { |axis| (axis * ADJUSTMENT).ceil }

        max_row = (1 << zoom) - 1

        (first_column..last_column).map do |column|
          (first_row..last_row).map do |row|
            blob = tile_blob(zoom, column, row)
            tile_id = Digest::MD5.hexdigest(blob)

            images[tile_id] = Database.blob(blob)
            values << [zoom, column, max_row - row, tile_id]
          end
        end
      end

      @mbtiles.import_images(images.to_a)
      @mbtiles.import_map(values)

      @mbtiles.adapter
    end
  end
end
