module MBTiles
  class TileSet
    def initialize(tile_list, fetcher)
      @tile_list = tile_list
      @fetcher = fetcher
    end

    def images_data
      @images_data ||= @fetcher.get(@tile_list)
    end

    def images
      @images ||= images_data.map do |i|
        {
          tile_id: Digest::MD5.hexdigest(i),
          tile_data: Database.blob(i)
        }
      end
    end

    def map
      @map ||= @tile_list.each_with_index.map do |tile, idx|
        {
          zoom_level: tile[0],
          tile_column: tile[1],
          tile_row: (1 << tile[0]) - 1 - tile[2],
          tile_id: images[idx][:tile_id]
        }
      end
    end

    def import(mbtiles)
      mbtiles.insert_images(images)
      mbtiles.insert_map(map)
    end
  end

  #class Tile
  #  attr_reader :id, :blob, :zoom, :column, :row

  #  def initialize(zoom, column, row, fetcher)
  #    @zoom, @column, @row = zoom, column, row
  #    @id, @blob = get_blob(zoom, column, row)
  #    @fetcher = fetcher
  #  end

  #  def get_blob(zoom, column, row)
  #    blob = @fetcher.get(zoom, column, row)

  #    if Utils::valid_image?(blob)
  #      id = Digest::MD5.hexdigest(blob)

  #      [id, blob]
  #    else
  #      raise InvalidImage.new([zoom, column, row].join('/'))
  #    end
  #  end
  #end
end
