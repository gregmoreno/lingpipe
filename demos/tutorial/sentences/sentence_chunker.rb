require 'lingpipe'
require 'java'
require 'pathname'

filename = Pathname(__FILE__).dirname + '../../data/sentence_demo.txt'
text = Java::java.lang.String.new(IO.read filename)

tokenizer = LingPipe::IndoEuropeanTokenizerFactory.new
sentence_model = LingPipe::MedlineSentenceModel.new
chunker = LingPipe::SentenceChunker.new(tokenizer, sentence_model)

chunking = chunker.chunk(text.toCharArray, 0, text.length)

text = chunking.charSequence
chunking.each_with_index do |sentence, count|
  puts "SENTENCE #{count + 1}:"
  puts text[sentence.start..sentence.end]
end
