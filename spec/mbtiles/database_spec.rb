require_relative '../spec_helper'
require 'tmpdir'

describe MBTiles do
  describe 'Database' do
    let(:db) do
      MBTiles::Database.new
    end

    let(:adapter) do
      db.adapter
    end

    describe '#create_schema!' do
      it 'has metadata table' do
        adapter.table_exists?(:metadata).must_equal true
      end

      it 'has images table' do
        adapter.table_exists?(:images).must_equal true
      end

      it 'has map table' do
        adapter.table_exists?(:map).must_equal true
      end

      it 'has tiles view' do
        adapter.views.include?(:tiles).must_equal true
      end

      it 'has map index' do
        expected_index = {
          map_index: {
            unique: true,
            columns: [:zoom_level, :tile_column, :tile_row]
          }
        }

        adapter.indexes(:map).must_equal expected_index
      end

      it 'has images index' do
        expected_index = { images_id: { unique: true, columns: [:tile_id] } }

        adapter.indexes(:images).must_equal expected_index
      end

      it 'has metadata index' do
        expected_index = { name: { unique: true, columns: [:name] } }

       adapter.indexes(:metadata).must_equal expected_index
      end
    end

    it '.blob' do
      MBTiles::Database.blob('').must_be_instance_of Sequel::SQL::Blob
    end

    it '.driver' do
      MBTiles::Database.driver.must_match(/\A(jdbc\:)?sqlite\z/)
    end

    it '#insert_metadata' do
      db.insert_metadata([{ name: 'name', value: 'value' }])

      adapter[:metadata].first(name: 'name', value: 'value').wont_be_nil
    end

    it '#insert_map' do
      db.insert_map([{ zoom_level: 0, tile_column: 0, tile_row: 0, tile_id: 0 }])

      adapter[:map].first(zoom_level: 0, tile_column: 0, tile_row: 0, tile_id: 0).wont_be_nil
    end

    it '#insert_images' do
      db.insert_images([{ tile_id: 0, tile_data: '' }])

      adapter[:images].first(tile_id: 0, tile_data: '').wont_be_nil
    end

    describe 'db path' do
      it 'in memory' do
        MBTiles::Database.new.adapter.url.must_match(/sqlite::memory:/)
      end

      describe 'in file' do
        let(:file) do
          "#{Dir.tmpdir}/test.db"
        end

        after do
          FileUtils.rm(file)
        end

        it 'absolute path' do
          MBTiles::Database.new(file).adapter.url.must_match(/sqlite:\/\/.*\/test.db/)
        end
      end
    end
  end
end
