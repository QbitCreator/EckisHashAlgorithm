load 'eckishashalg.rb'


def bruteforcetest(crypt, max_word_length, chars)
	chars=chars.chars
	@hashtable=[]
	@clearcount=0
	@collisions=0
	@hashtime=0
	@searchtime=0

	for n in 1..max_word_length do
		track=Array.new(n, 0)
		for m in 1..((chars.size)**n).ceil do
			starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			b=0
			while track[b]>chars.size-1
				track[(b+1)]+=1
				track[b]=0
				b+=1
			end
			cleartext=""
			track.each do |x|
				cleartext+=chars[x]
			end
			hashstarting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			result=eckisHashAlg(cleartext)
			hashending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			hashelapsed = hashending-hashstarting
			@hashtime+=hashelapsed
			#if @hashtable.include? result
			#	@collisions+=1
			#else
			#	@hashtable.append(result)
			#end
			if result==crypt 
				return cleartext, result
			end
			@clearcount+=1
			puts(result+" "+cleartext)
			track[0]+=1
			ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
			elapsed = ending-starting
			@searchtime+=elapsed
		end			
	end
end

puts("Geben Sie einen Hash ein: ")
test=gets.chomp
puts("Geben Sie die maximale Klartextlänge ein: ")
wordsize=gets.chomp.to_i

#test=eckisHashAlg(hashtest)
#puts(test)
chars=" 0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"

result=bruteforcetest(test, wordsize, chars)

puts()
puts("Klartext: "+result[0])
puts("Hash: "+result[1])
#puts("Hashes: "+@hashtable.size.to_s)
puts("Klartexte: "+@clearcount.to_s)
#puts("Kollisionen: "+@collisions.to_s)
puts("Durchschnittliche Hashzeit: "+(@hashtime.to_f/@clearcount.to_f).to_s)
puts("Durchschnittliche Suchzeit/Wort: "+(@searchtime.to_f/@clearcount.to_f).to_s)