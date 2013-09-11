# MBTiles

MBTiles reading and writing library. Based on MBTiles specification
version 1.1.

[See MBTiles-spec](https://github.com/mapbox/mbtiles-spec).

**Note that this is pre-alpha stage library and may not work at all or fit
your needs.**

## Installation

Add this line to your application's Gemfile:

    gem 'mbtiles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mbtiles

## Usage

```ruby
require 'mbtiles'

# tilebox_url = 'http://tiles.tld/osm'
fetcher = MBTiles::ParallelFetcher.new(tilebox_url)
coords = [59.950675,30.291254,59.949888,30.292638]
path = '/tmp/sample.mbtiles'
zoom_levels = [0, 10]

MBTiles::Writer.new(coords, fetcher, zoom_levels, path).save
```

There is lack of documentation at the moment, so for additional info please
[see specs](https://github.com/etehtsea/mbtiles-ruby/tree/master/spec).

## Development
For development needs you can `mock!` all requests to external source.

``` ruby
fetcher = MBTiles::ParallelFetcher.new("http://#{tilebox_url}", 60)
fetcher.mock! # unless YOUR_ENV == 'production'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
