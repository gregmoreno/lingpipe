require 'lingpipe'
require 'java'
require 'pathname'

def build_model(tokenizer_factory, ngram, pathname)
  model = LingPipe::TokenizedLM.new(tokenizer_factory, ngram)
  
  puts "Training on directory #{pathname}"
  pathname.children.select{ |p| not p.directory? }.each do |f|
    text = IO.read(f.realpath)
    model.handle(text)
  end
  model 
end

def report(ngrams)
  ngrams.each do |ngram|
    tokens = ngram.getObject
    printf "Score: %f with : %s\n", ngram.score, tokens.collect.join(' ')
  end
end

NGRAM = 3
MIN_COUNT = 5
MAX_NGRAM_REPORTING_LENGTH = 2
NGRAM_REPORTING_LENGTH = 2
MAX_COUNT = 100


background_dir = Pathname(__FILE__).dirname + '../../data/rec.sport.hockey/train'
foreground_dir = Pathname(__FILE__).dirname + '../../data/rec.sport.hockey/test'

tokenizer_factory = LingPipe::IndoEuropeanTokenizerFactory.new

puts 'Training background model'

background_model = build_model(tokenizer_factory, NGRAM, background_dir)
background_model.sequenceCounter.prune(3)

puts 'Assembling collocations in Training'
collection = background_model.collocationSet(NGRAM_REPORTING_LENGTH, MIN_COUNT, MAX_COUNT)

puts 'Collocations in Order of Significance'
report collection

puts 'Training foreground model'

foreground_model = build_model(tokenizer_factory, NGRAM, foreground_dir)
foreground_model.sequenceCounter.prune(3)

puts 'Assembling New Terms in Test vs. Training'
new_terms = foreground_model.newTermSet(NGRAM_REPORTING_LENGTH, MIN_COUNT, MAX_COUNT, background_model)

puts 'New Terms in Order of Significance'
report new_terms

puts 'Done'









