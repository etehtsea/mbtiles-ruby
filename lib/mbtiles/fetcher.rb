require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module MBTiles
  class ParallelFetcher
    def initialize(url, timeout = 30)
      @url = url
      @conn = Faraday.new(url: url, request: { timeout: timeout }) do |f|
        f.adapter :typhoeus
      end
    end

    def mock!
      response = Typhoeus::Response.new(code: 200, body: '')
      Typhoeus.stub(/#{@url}/).and_return(response)
    end

    def get(tile_list)
      responses = []

      @conn.in_parallel do
        tile_list.each do |tile|
          zoom, column, row = tile

          path = ['/osm', zoom, column, row].join('/') << '.png'
          responses << @conn.get(path)
        end
      end

      if responses.all? { |r| r.status == 200 }
        responses.map(&:body)
      else
        errs = responses.select { |r| r.status != 200 }
        raise RuntimeError, errs.map(&:status)
      end
    end
  end

  class Fetcher
    def initialize(url, timeout)
      @conn = Faraday.new(url: url, request: {timeout: timeout})
    end

    def get(tile_list)
      tile_list.map do |tile|
        zoom, column, row = tile
        path = ['/osm', zoom, column, row].join('/') << '.png'

        @conn.get(path).body
      end
    end
  end
end
