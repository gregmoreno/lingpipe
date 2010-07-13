require 'lingpipe'

CHUNK_SCORE = 1.0
entries = [
  ['50 Cent',           'PERSON',        CHUNK_SCORE],
  ['XYZ120 DVD Player', 'DB_ID_1232',    CHUNK_SCORE],
  ['cent',              'MONETARY_UNIT', CHUNK_SCORE],
  ['dvd player',        'PRODUCT',       CHUNK_SCORE]
]

chunker = LingPipe::ExactDictionaryChunker.new
chunker.dictionary = entries

#puts "Dictionary"
#puts chunker.dictionary

samples = [
  "50 Cent is hard to distinguish from 50 cent and just plain cent without case",
  "The product xyz120 DVD player won't match unless it's exact like XYZ120 DVD Player.",
  "sample nothing"
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
