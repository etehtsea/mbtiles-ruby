require 'mbtiles'
require 'sequel'
require 'minitest/autorun'
require 'turn'

Turn.config do |c|
  c.ansi = true
  c.format = :outline
end
