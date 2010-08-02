module LingPipe

  module Tokenizer

    class << self
      def indo_european
        factory(:indo_european)
      end

      def token_length(factory_name, min, max)
        factory(:token_length, factory(factory_name), min, max) 
      end

      def n_gram(min, max)
        factory(:n_gram, min, max)
      end

      def factory(name, *args)
        klass_name = name.to_s.classify + 'TokenizerFactory'
        module_klass = "#{self}::" + klass_name

        begin
          klass = module_klass.constantize
        rescue NameError => e
          # This allows us dynamically load Java classes and add the corresponding alias
          # to this module's namespace. 
          #
          # > 'LingPipe::Tokenizer.indo_european' 
          #
          # will also define LingPipe::Tokenizer::IndoEuropeanTokenizerFactory
          # Thus, we can now also do LingPipe::Tokenizer::IndoEuropeanTokenizerFactory.new()

          klass = self.const_set(klass_name, Java.send("com.aliasi.tokenizer.#{klass_name}"))
        end

        klass.new(*args)
      end

    end

  end # module Tokenizer

end
