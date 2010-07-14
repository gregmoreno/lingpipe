require 'lingpipe'
require 'java'
require 'pathname'

filename = Pathname(__FILE__).dirname + '../../data/sentence_demo.txt'
text = Java::java.lang.String.new(IO.read filename)

tokenizer = LingPipe::IndoEuropeanTokenizerFactory.new.tokenizer(text.toCharArray, 0, text.length) 


token_list = []
white_list = []
tokenizer.tokenize(token_list, white_list)

puts "#{token_list.size} TOKENS"
puts "#{white_list.size} WHITESPACES"

# because ruby array != java array
tokens = token_list.to_java(:string)
whites = white_list.to_java(:string)
sentence_boundaries = LingPipe::MedlineSentenceModel.new.boundaryIndices(tokens, whites)

puts "#{sentence_boundaries.length} SENTENCE END TOKEN OFFSETS"

start_token = 0
sentence_boundaries.each_with_index do |end_token, count|
  puts "SENTENCE #{count + 1}:"

  start_token.upto(end_token) do |j|
    print "#{tokens[j]}#{whites[j+1]}"
  end
  puts ""

  start_token = end_token + 1
end
