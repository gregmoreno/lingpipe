
def TokenizedLM(options)
  LingPipe::TokenizedLM.new(options)
end

module LingPipe

  class TokenizedLM
    attr_accessor :model
    alias_method :instance, :model
    
    def initialize(options)
      tokenizer_factory = options[:tokenizer] || Tokenizer.factory(:indo_european)
      @model = LingPipe::LM::TokenizedLM.new(tokenizer_factory, options[:ngram])
    end

    def collocations(*args)
      @model.collocationSet(*args).inject([]) do |l, ngram|
        l << [ngram.getObject.collect.join(' '), ngram.score]
      end
    end

    def train(source)
      send("train_with_#{source.class.to_s.downcase}", source)
    end

    def train_with_string(text)
      @model.train(text)
    end

    def train_with_pathname(pathname)
      if pathname.directory?
        pathname.children.map{ |p| train_with_pathname(p) }
      else
        train_with_string(IO.read(pathname.realpath))
      end
    end

  end  # class TokenizedLM

  module LM
    TokenizedLM = Java::com.aliasi.lm.TokenizedLM
  end
  
end
