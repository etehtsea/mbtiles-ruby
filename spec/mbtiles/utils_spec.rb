require_relative '../spec_helper'

describe MBTiles do
  describe '::Utils' do
    describe '.coords2tile' do
      it do
        MBTiles::Utils.coords2tile(1, 1, 1).must_equal [0, 1]
      end

      it do
        MBTiles::Utils.coords2tile(51.51202, 0.02435, 17).must_equal [65544, 43582]
      end
    end

    describe '.valid_image?' do
      it 'for valid' do
        png = "\x89PNG\r\n\x1A\n\x00\x00\x00".force_encoding('ASCII-8BIT')

        MBTiles::Utils.valid_image?(png).must_equal true
      end

      it 'for invalid' do
        MBTiles::Utils.valid_image?('').must_equal false
      end
    end

    describe '.tile2coords' do
      it do
        MBTiles::Utils.tile2coords(65544, 43582, 17).must_equal [51.51216, 0.02197]
      end
    end
  end
end
