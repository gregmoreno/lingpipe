require 'lingpipe'
require 'pathname'
require 'java'


MAX_N_GRAM = 8
NUM_CHARS = 256
LM_INTERPOLATION = MAX_N_GRAM # default behavior

puts "Setting up Chunker Estimator"

tokenizer = LingPipe::IndoEuropeanTokenizerFactory.new
hmm_estimator = LingPipe::HmmCharLmEstimator.new(MAX_N_GRAM, NUM_CHARS, LM_INTERPOLATION)
chunker_estimator = LingPipe::CharLmHmmChunker.new(tokenizer, hmm_estimator)

puts "Setting up Data Parser"

parser = LingPipe::GeneTagParser.new
parser.setHandler(chunker_estimator)

puts "Training with Data from File"

filename = Pathname(__FILE__).dirname + 'TODO'
corpusFile = Java::java.io.File.new(filename.to_s) # NOTE: Ruby file != java.io.File
parser.parse(corpusFile)

puts "Compiling and Writing Model to File"
LingPipe::AbstractExternalizable.compileTo(chunker_estimator, modelFile)





