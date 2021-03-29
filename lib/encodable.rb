module Encodable
  ZERO = '0'.freeze
  ONE = '1'.freeze

  def encode(row)
    chars_counts = row.chars.group_by(&:itself).transform_values(&:count).map do |char, count|
      { char: char, count: count }
    end
    tree = build_tree(chars_counts)
    { tree: tree, input: row, output: encoded_string(row, tree) }
  end

  private

  def encoded_string(row, tree)
    char_bits = char_bits(tree)
    row.chars.map { |char| char_bits[char] }.join
  end

  def build_tree(chars_counts)
    return formatted_node(chars_counts.first) if chars_counts.count == 1

    chars_min_counts = chars_counts.min_by(2) { |char_count| char_count[:count] }
    chars_min_counts.each { |char_min_count| chars_counts.delete(char_min_count) }
    chars_counts.append(node(chars_min_counts))
    build_tree(chars_counts)
  end

  def node(chars_min_counts)
    {
      ZERO => formatted_node(chars_min_counts[0]),
      ONE => formatted_node(chars_min_counts[1]),
      count: chars_min_counts.sum { |char_min_count| char_min_count[:count] }
    }
  end

  def formatted_node(node)
    node.fetch(:char, node.slice(ONE, ZERO))
  end

  def char_bits(node, bits = '')
    return {}.merge(char_bits(node[ZERO], bits + ZERO)).merge(char_bits(node[ONE], bits + ONE)) if node.is_a?(Hash)

    node.is_a?(String) ? { node => bits } : {}
  end
end
