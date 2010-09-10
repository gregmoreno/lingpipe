require 'java'

MapDictionary   = Java::com.aliasi.dict.MapDictionary
DictionaryEntry = Java::com.aliasi.dict.DictionaryEntry

entries = [
  ['50 Cent',    'Person',           1.0],
  ['XYZ120 DVD Player', 'DB_ID1232', 1.0],
  ['cent',       'MONETARY_UNIT',    1.0],
  ['dvd player', 'PRODUCT',          1.0],
]

dictionary = MapDictionary.new
entries.each do |entry|
  dictionary.addEntry DictionaryEntry.new(*entry)
end

# Print the entries in our dictionary
puts "** Dictionary"
dictionary.each do |entry|
  puts entry
end
puts "******"

ExactDictionaryChunker = Java::com.aliasi.dict.ExactDictionaryChunker
IndoEuropeanTokenizerFactory = Java::com.aliasi.tokenizer.IndoEuropeanTokenizerFactory

chunker = ExactDictionaryChunker.new(
  dictionary,
  IndoEuropeanTokenizerFactory.new, 
  true, true)

samples = [
  "50 Cent is hard to distinguish from 50 cent and just plain cent without case",
  "The product xyz120 DVD player won't match unless it's exact like XYZ120 DVD Player.",
  "This will not match"
]

samples.each do |text|
  puts "sentence = #{text}"

  chunking = chunker.chunk(text)
  chunking.each do |chunk|
    phrase = text[chunk.start..chunk.end]
    puts "phrase = #{phrase}"
  end
  
  puts "*********"
end

