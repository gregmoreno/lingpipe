def SentenceChunker(options)
  LingPipe::SentenceChunker.new(options)
end

module LingPipe

  class SentenceChunker
    attr_accessor :chunker
    alias_method :instance, :chunker

    def initialize(options)
      tokenizer_factory = options[:tokenizer] || Tokenizer.indo_european 
      sentence_model = Sentence.model(options[:sentence_model])
      @chunker = Sentence::SentenceChunker.new(tokenizer_factory, sentence_model)
    end

    # use chunk() if you need the score and other attributes
    def chunk(text)
      @chunker.chunk(text)
    end

    def split(text)
      chunk(text).inject([]) do |l, bound|
        l << text[bound.start..bound.end]
      end
    end
  end

  module Sentence
    SentenceChunker = Java::com.aliasi.sentences.SentenceChunker
    MedlineSentenceModel = Java::com.aliasi.sentences.MedlineSentenceModel

    def self.model(name = :medline)
      klass_name = name.to_s.classify + 'SentenceModel'
      "#{self}::#{klass_name}".constantize.new
    end
  end

end
