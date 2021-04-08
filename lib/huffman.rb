# frozen_string_literal: true

require_relative 'encodable'
require_relative 'decodable'
require 'pry'

class Huffman
  extend Encodable
  extend Decodable
end
