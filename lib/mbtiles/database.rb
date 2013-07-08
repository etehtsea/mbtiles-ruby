require 'sequel'

module MBTiles
  class Database
    def initialize(path = nil)
      storage_type = path ? "//#{path}" : ':memory:'

      @path = path
      @db = Sequel.connect("#{self.class.driver}:#{storage_type}")

      create_schema!
    end

    def self.driver
      @driver ||= RUBY_PLATFORM == 'java' ? 'jdbc:sqlite' : 'sqlite'
    end

    def self.blob(blob)
      Sequel.blob(blob)
    end

    def adapter
      @db
    end

    def insert_metadata(records)
      @db[:metadata].multi_insert(records)
    end

    def insert_map(records)
      @db[:map].multi_insert(records)
    end

    def insert_images(records)
      @db[:images].multi_replace(records)
    end

    def create_schema!
      @db.create_table :metadata do
        Text :name
        Text :value

        index :name, unique: true, name: 'name'
      end

      @db.create_table :map do
        Integer :zoom_level
        Integer :tile_column
        Integer :tile_row
        Text    :tile_id

        index [:zoom_level, :tile_column, :tile_row], unique: true, name: 'map_index'
      end

      @db.create_table :images do
        Text :tile_id
        Blob :tile_data

        index :tile_id, unique: true, name: 'images_id'
      end

      view_query = 'SELECT
        map.zoom_level AS zoom_level,
        map.tile_column AS tile_column,
        map.tile_row AS tile_row,
        images.tile_data AS tile_data
        FROM map JOIN images ON images.tile_id = map.tile_id;'
      @db.create_view(:tiles, view_query)
    end

    def size
      @path ? File.size(@path) : nil
    end

    def md5
      @path ? Digest::MD5.file(@path).hexdigest : nil
    end
  end
end
