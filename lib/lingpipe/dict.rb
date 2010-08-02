def ExactDictionaryChunker(options)
  LingPipe::ExactDictionaryChunker.new(options)
end

def ApproxDictionaryChunker(options)
  LingPipe::ApproxDictionaryChunker.new(options)
end

def MapDictionary(entries)
  dictionary = LingPipe::Dict::MapDictionary.new
  entries.each do |entry|
    dictionary.addEntry(LingPipe::Dict::DictionaryEntry.new(*entry))
  end
  dictionary
end

def TrieDictionary(entries)
  dictionary = LingPipe::Dict::TrieDictionary.new
  entries.each do |entry|
    dictionary.addEntry(LingPipe::Dict::DictionaryEntry.new(*entry))
  end
  dictionary
end

module LingPipe
  
  class ExactDictionaryChunker
    
    def initialize(options)
      tokenizer_factory = options[:tokenizer] || Tokenizer.factory(:indo_european)
      @chunker = Dict::ExactDictionaryChunker.new(options[:dictionary],
                                                           tokenizer_factory)
    end

    def chunk(text)
      @chunker.chunk(text)
    end

  end # class ExactDictionaryChunker

  class ApproxDictionaryChunker
    def initialize(options)
      tokenizer_factory = options[:tokenizer] || Tokenizer.factory(:indo_european)
      @chunker = Dict::ApproxDictionaryChunker.new(
                    options[:dictionary],
                    tokenizer_factory,
                    options[:distance_measure],
                    options[:distance_threshold])
    end

    def chunk(text)
      @chunker.chunk(text)
    end

  end # class ApproxDictionaryChunker


  module Dict
    ExactDictionaryChunker  = Java::com.aliasi.dict.ExactDictionaryChunker
    ApproxDictionaryChunker = Java::com.aliasi.dict.ApproxDictionaryChunker

    MapDictionary          = Java::com.aliasi.dict.MapDictionary
    TrieDictionary         = Java::com.aliasi.dict.TrieDictionary
    DictionaryEntry        = Java::com.aliasi.dict.DictionaryEntry

  end

end
