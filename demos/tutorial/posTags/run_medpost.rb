require 'lingpipe'
require 'java'
require 'pathname'

filename = Pathname(__FILE__).dirname + '../../models/pos-en-bio-medpost.HiddenMarkovModel'
model = Java::java.io.File.new(filename.to_s) # NOTE: Ruby file != java.io.File
hmm = LingPipe::AbstractExternalizable.readObject(model);
decoder = LingPipe::HmmDecoder.new(hmm)

TOKEN_REGEX = "(-|'|\\d|\\p{L})+|\\S"
tokenizer_factory = LingPipe::RegExTokenizerFactory.new(TOKEN_REGEX)
sample = "This correlation was also confirmed by detection of early carcinoma."
tokenizer = tokenizer_factory.tokenizer(Java::java.lang.String.new(sample).toCharArray, 0, sample.length)

# damn conversion
tokens = tokenizer.tokenize 
a_tokens = tokens.inject([]) { |l, i| l << i } 
j_tokens = a_tokens.to_java(:string)
token_list = Java::java.util.Arrays.asList(j_tokens)  # (tokenizer.tokenize) doesn't work

puts sample

puts "FIRST BEST"

tagging = decoder.tag(token_list)
0.upto(tagging.size - 1) do |i|
  print "#{tagging.token(i)}_#{tagging.tag(i)} "
end
puts ""

puts 'N BEST'
puts '#  JointLogProb   Analysis'

taggings = decoder.tagNBest(token_list, 5)
taggings.each_with_index do |tagging, n|
  printf "%s %9.3f      ", n, tagging.score

  0.upto(token_list.size - 1) do |i|
    print "#{tagging.token(i)}_#{tagging.tag(i)} "
  end
  puts ""
end

puts 'CONFIDENCE'
printf "%-3s  %-15s\n", '#', 'Token', '(Prob:Tag)*'

lattice = decoder.tagMarginal(token_list)

0.upto(token_list.size - 1) do |token_index|
  printf "%-3s  %-15s", token_index, token_list[token_index]

  tag_scores = lattice.tokenClassification(token_index)
  0.upto(4) do |i|
    prob = tag_scores.score(i)
    tag = tag_scores.category(i)
    printf "%9.3f:%-4s", prob, tag
  end

  puts ''
end
