require 'yaml'
require_relative 'lib/haffman'

INPUT_FILE = 'input.yml'.freeze
OUTPUT_FILE = 'output.yml'.freeze

input = YAML.safe_load(File.open(INPUT_FILE))['input']

haffman = Haffman.encode(input)
File.open(INPUT_FILE, 'w') { |file| file.write(haffman.transform_keys(&:to_s).to_yaml) }

decoded_row = Haffman.decode(haffman[:output], haffman[:tree])
File.open(OUTPUT_FILE, 'w') { |file| file.write({ 'output' => decoded_row }.to_yaml) }
