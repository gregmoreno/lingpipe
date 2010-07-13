require 'lingpipe'
require 'pathname'
require 'java'

filename = Pathname(__FILE__).dirname + '../../models/ne-en-bio-genetag.HmmChunker'
model = Java::java.io.File.new(filename.to_s) # NOTE: Ruby file != java.io.File
chunker = LingPipe::AbstractExternalizable.readObject(model);

sample = "p53 regulates human insulin-like growth factor II gene expression through active P4 promoter in rhabdomyosarcoma cells."

MAX_N_BEST_CHUNKS = 8

s = Java::java.lang.String.new(sample).toCharArray # because nBestChunks expects a char[]
chunking = chunker.nBestChunks(s, 0, sample.length, MAX_N_BEST_CHUNKS)
rank = 0
chunking.each do |chunk|
  conf = 2.0**chunk.score
  phrase = sample[chunk.start..chunk.end] 
  printf "%2d %12.4f (%2d, %2d) %s %s\n", rank, conf, chunk.start, chunk.end, chunk.type, phrase
  rank += 1  
end
