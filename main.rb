require 'yaml'
require_relative 'lib/haffman'

haffman = Haffman.encode_file('input')
# File.open(INPUT_FILE, 'w') { |file| file.write(haffman.transform_keys(&:to_s).to_yaml) }

Haffman.decode_file('input_encoded', haffman[:tree], haffman[:trash_count])
# File.open(OUTPUT_FILE, 'w') { |file| file.write({ 'output' => decoded_row }.to_yaml) }
