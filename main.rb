# frozen_string_literal: true

require_relative 'lib/huffman'

file_name = ARGV[0]
Huffman.encode_file(file_name)
Huffman.decode_file(file_name + Encodable::ENCODED_SUFFIX)
