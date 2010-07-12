require 'lingpipe'

entries = [
  ['P53', 'P53'],
  ['protein 53', 'P53'],
  ['Mdm', 'Mdm']
]

chunker = LingPipe::ApproxDictionaryChunker.new
chunker.dictionary = entries

#puts "Dictionary"
#puts chunker.dictionary

samples = [
  "A protein called Mdm2 binds to p53 and transports it from the nucleus to the cytosol.",
  "p53, also known as protein 53 (TP53), functions as a tumor supressor."
]

results = chunker.chunk(samples)
results.each do |chunking|
  text = chunking.charSequence
  puts "TEXT = #{text}"

  chunking.each do |chunk|
    phrase = text[chunk.start..chunk.end]
    puts "phrase = #{phrase}"
  end
end
