require_relative '../spec_helper'

describe MBTiles do
  describe 'Writer' do
    let(:mbtiles) do
      MBTiles::Writer.new([59.950675,30.291254,59.949888,30.292638], Object.new)
    end

    it '#tile_list' do
      (0..16).reduce([]) { |sum, z| sum + mbtiles.tile_list(z) }.count.must_equal 569
    end

    it '#center' do
      mbtiles.center.must_equal [30.291946, 59.950282, 8]
    end

    it '#bounds' do
      mbtiles.bounds.must_equal [30.291254, 59.949888, 30.292638, 59.950675]
    end
  end
end
