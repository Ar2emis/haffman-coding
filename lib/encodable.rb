module Encodable
  INPUT_FILE = 'input.yml'.freeze
  ENCODED_SUFFIX = '_encoded'.freeze
  ZERO = '0'.freeze
  ONE = '1'.freeze
  BITS = 8

  def encode_file(file_name)
    encoded = encode(File.open(file_name).read)
    # File.open(INPUT_FILE, 'w') { |input_file| input_file.write(encoded.transform_keys(&:to_s).to_yaml) }
    File.open(file_name + ENCODED_SUFFIX, 'w') do |f|
      f.write(encoded.slice(:tree, :trash_count).to_s + "\n")
      f.write(encoded[:output])
    end
    encoded
  end

  def encode(row)
    chars_counts = row.chars.group_by(&:itself).transform_values(&:count).map do |char, count|
      { char: char, count: count }
    end
    tree = build_tree(chars_counts)
    { tree: tree, input: row }.merge(encoded_string(row, tree))
  end

  private

  def encoded_string(row, tree)
    char_bits = char_bits(tree)
    binary = row.chars.map { |char| char_bits[char] }.join
    trash_count = BITS - binary.length % BITS
    encoded = (binary + ZERO * trash_count).scan(/.{#{BITS}}/).map { |binary_char| binary_char.to_i(2).chr }.join
    { output: encoded, binary_output: binary, trash_count: trash_count }
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
