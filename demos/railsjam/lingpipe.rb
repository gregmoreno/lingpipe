require 'java'
require 'rails'

module LingPipe

  MapDictionary   = Java::com.aliasi.dict.MapDictionary
  DictionaryEntry = Java::com.aliasi.dict.DictionaryEntry

  ExactDictionaryChunker = Java::com.aliasi.dict.ExactDictionaryChunker
  IndoEuropeanTokenizerFactory = Java::com.aliasi.tokenizer.IndoEuropeanTokenizerFactory
  
  def self.tokenizer(name)
    klass = name.to_s.camelize
    Java::send("com.aliasi.tokenizer.#{klass}TokenizerFactory")
  end
end
