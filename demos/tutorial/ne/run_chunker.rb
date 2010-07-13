require 'lingpipe'
require 'pathname'
require 'java'

filename = Pathname(__FILE__).dirname + '../../models/ne-en-bio-genetag.HmmChunker'
model = Java::java.io.File.new(filename.to_s) # NOTE: Ruby file != java.io.File
chunker = LingPipe::AbstractExternalizable.readObject(model);

sample = "p53 regulates human insulin-like growth factor II gene expression through active P4 promoter in rhabdomyosarcoma cells."

chunking = chunker.chunk(sample)
puts "Chunking=#{chunking}"
