require 'java'

module LingPipe
  DictionaryEntry = Java::com.aliasi.dict.DictionaryEntry
  MapDictionary = Java::com.aliasi.dict.MapDictionary
  IndoEuropeanTokenizerFactory = Java::com.aliasi.tokenizer.IndoEuropeanTokenizerFactory
  TrieDictionary = Java::com.aliasi.dict.TrieDictionary

  HmmCharLmEstimator = Java::com.aliasi.hmm.HmmCharLmEstimator
  CharLmHmmChunker = Java::com.aliasi.chunk.CharLmHmmChunker

  AbstractExternalizable = Java::com.aliasi.util.AbstractExternalizable

  MedlineSentenceModel = Java::com.aliasi.sentences.MedlineSentenceModel
  SentenceChunker = Java::com.aliasi.sentences.SentenceChunker
  SentenceModel = Java::com.aliasi.sentences.SentenceModel

  class ExactDictionaryChunker
    def initialize
      @tokenizer = IndoEuropeanTokenizerFactory.new  
    end

    def dictionary(entries = nil)
      return @dictionary unless entries 

      @dictionary = MapDictionary.new
      entries.each do |entry|
        @dictionary.addEntry(DictionaryEntry.new(*entry))
      end
    end
    alias_method :dictionary=, :dictionary

    def chunk(text)
      text.inject([]) do |chunks, s|
        chunks << chunker.chunk(s)
      end
    end

    private

    # TODO: 
    # @dictionary and @tokenizer could be nil at this point
    # parameterized the allMatch and case options
    def chunker
      @chunker ||= Java::com.aliasi.dict.ExactDictionaryChunker.new(@dictionary, @tokenizer, true, false)
    end

  end # class ExactDictionaryChunker


  class ApproxDictionaryChunker
    def initialize
      @tokenizer = IndoEuropeanTokenizerFactory.new  
      @edit_distance = Java::com.aliasi.spell.FixedWeightEditDistance.new(0, -1, -1, -1, 0.0) # Java::java.lang.Double.naN)
      @max_distance = 2.0
    end

    def dictionary(entries = nil)
      return @dictionary unless entries 

      @dictionary = TrieDictionary.new
      entries.each do |entry|
        @dictionary.addEntry(DictionaryEntry.new(*entry))
      end
    end
    alias_method :dictionary=, :dictionary

    def chunk(text)
      text.inject([]) do |chunks, s|
        chunks << chunker.chunk(s)
      end
    end

    private

    # TODO: 
    # @dictionary and @tokenizer could be nil at this point
    def chunker
      @chunker ||= Java::com.aliasi.dict.ApproxDictionaryChunker.new(@dictionary, @tokenizer, @edit_distance, @max_distance)
    end

  end

end
