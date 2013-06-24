require_relative '../spec_helper'

describe MBTiles do
  describe 'Writer' do
    let(:mbtiles) do
      mbtiles = MBTiles::Writer.new([59.950675,30.291254,59.949888,30.292638], Object.new)

      mbtiles.stub :tile_blob, '' do
        mbtiles.save
      end
    end

    it 'tile number' do
      mbtiles[:tiles].count.must_equal 569
    end

    it '#center' do
      center = [13.377228, 52.517057, 8]

      MBTiles::Writer.new([52.517892228, 13.375854492, 52.516220864, 13.378601074], '').center.must_equal center
    end

    it '#bounds' do
      bounds = [13.375854, 52.516221, 13.378601, 52.517892]
      MBTiles::Writer.new([52.517892228, 13.375854492, 52.516220864, 13.378601074], '').bounds.must_equal bounds
    end
  end
end
