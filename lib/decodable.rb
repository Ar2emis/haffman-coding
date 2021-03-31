module Decodable
  DECODED_SUFFIX = '_decoded'.freeze

  def decode_file(file_name, tree, trash_count)
    decoded_row = decode(File.open(file_name).read, tree, trash_count)
    File.open(file_name + DECODED_SUFFIX, 'w') { |file| file.write(decoded_row) }
    decoded_row
  end

  def decode(row, tree, trash_count)
    decoded_row = ''
    row.unpack('B*').first[0..-trash_count].chars.inject(tree) do |node, char|
      next node[char] if node.is_a?(Hash)

      decoded_row += node
      tree[char]
    end
    decoded_row
  end
end
