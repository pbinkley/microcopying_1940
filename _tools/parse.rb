#! /usr/bin/env ruby

require 'nokogiri'
require 'byebug'

doc = File.open("_site/index.html") { |f| Nokogiri::XML(f) }
speeches = doc.xpath('//div[@class = "speech"]')   
puts "Speeches: #{speeches.count}"

longestspeech = 0
speakers = {}

speeches.each_with_index do |speech, index|
	speaker = speech.xpath('p/span[@class="speaker"]/@data-speaker').text

	speakers[speaker] = [] unless speakers[speaker]
	speakers[speaker] << speech

	paras = speech.xpath('p')
	wordcount = paras.text.split(' ').count
	longestspeech = wordcount if wordcount > longestspeech
	puts "Speaker: #{speaker} - #{paras.count} paras, #{wordcount} words"    
#	byebug
end

puts ""
puts "Longest speech: #{longestspeech}"
puts "Speakers: #{speakers.count}"
puts ""

stats = {}
speakers.keys.sort.each do |speaker|
	wordcount = 0
	questions = 0
	speakers[speaker].each do |speech|
		wordcount += speech.text.split(' ').count
		questions += speech.text.gsub(/[^\?]/, '').length
	end
	stats[speaker] = {speeches: speakers[speaker].count, words: wordcount, questions: questions, qperw: questions.to_f/wordcount}
	puts "#{speaker}: #{stats[speaker]}"
end
puts 'ok'

