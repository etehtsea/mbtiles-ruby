require 'digest/md5'
require 'mbtiles/utils'
require 'mbtiles/database'
require 'mbtiles/fetcher'
require 'mbtiles/tileset'

# y, x == lat, lon == row, col

module MBTiles
  class InvalidImage < Exception; end

  class Writer
    include Utils

    ADJUSTMENT = 1.0003

    def initialize(coords, fetcher, path = nil)
      @coords = coords
      @mbtiles = Database.new(path)
      @min_zoom, @max_zoom = [0, 16]
      @fetcher = fetcher
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
        { 'name'    => 'sample' },
        { 'version' => '1.0.0' },
        { 'format'  => 'png' },
        { 'description' => 'description' }
      ].map { |m| { name: m.keys.first, value: m.values.first } }

      @mbtiles.insert_metadata(metadata)
    end

    def save
      write_metadata!

      (@min_zoom..@max_zoom).each do |zoom|
        tile_list(zoom).each_slice(30) do |t|
          TileSet.new(t, @fetcher).import(@mbtiles)
        end
      end

      @mbtiles
    end

    def tile_list(zoom)
      min_xy = coords2tile(*@coords.first(2), zoom)
      max_xy = coords2tile(*@coords.last(2), zoom)

      first_column, first_row = min_xy.map { |axis| (axis / ADJUSTMENT).to_i }
      last_column, last_row = max_xy.map { |axis| (axis * ADJUSTMENT).ceil }

      cols = (first_column..last_column).to_a
      rows = (first_row..last_row).to_a

      cols.flat_map { |c| rows.map { |r| [zoom, c, r] } }
    end
  end
end
