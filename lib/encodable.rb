# frozen_string_literal: true

module Encodable
  ENCODED_SUFFIX = '.encoded'
  ZERO = '0'
  ONE = '1'
  BITS = 8

  def encode_file(file_name)
    encoded = encode(File.open(file_name).read)
    File.open(file_name + ENCODED_SUFFIX, 'w') { |f| f.write(encoded) }
  end

  def encode(row)
    prepared_row = row.unpack1('A*')
    tree = tree(prepared_row)
    char_bits = char_bits(tree)
    binary = prepared_row.chars.map { |char| char_bits[char] }.join
    trash_count = BITS - binary.length % BITS
    build_row(transform_to_chars(binary + ZERO * trash_count), tree: tree, trash_count: trash_count)
  end

  private

  def transform_to_chars(binary)
    binary.scan(/.{#{BITS}}/).map { |binary_char| binary_char.to_i(2).chr }.join
  end

  def build_row(encoded, **kwargs)
    "#{kwargs}\n#{encoded}"
  end

  def weights_matrix(row)
    row.chars.uniq.map { |char| [char, row.count(char)] }
  end

  def build_tree(matrix)
    return matrix.dig(0, 0) if matrix.count == 1

    lightest_rows = matrix.min_by(2, &:last)
    build_tree((matrix - lightest_rows) << row(lightest_rows))
  end

  def row(lightest_rows)
    [node(*lightest_rows.map(&:first)), lightest_rows.sum(&:last)]
  end

  def node(left_node, right_node = nil)
    { ZERO => left_node, ONE => right_node }
  end

  def tree(row)
    matrix = weights_matrix(row)
    matrix.count == 1 ? node(matrix.dig(0, 0)).compact : build_tree(matrix)
  end

  def char_bits(node, bits = '')
    node.is_a?(String) ? { node => bits } : char_bits(node[ZERO], bits + ZERO).merge(char_bits(node[ONE], bits + ONE))
  end
end
