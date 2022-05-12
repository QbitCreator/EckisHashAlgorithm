def eckisHashAlg(input)
	hashsize=64 	#Einstellen der Hashgröße in Zeichen
#_________________________________Square and Multiply für Modulares Potenzieren_________________________________________________
	def sqmul(a, g ,p)
		cache=g
		a.chars.each_with_index do |x, i|
			if i!=0
				cache=(cache**2)%p
				cache=(cache*(g**a[x].to_i))%p
			end
		end
		return cache
	end
#_________________________________Input in ascii umwandeln_______________________________________________________________________
	input=input.bytes

#_________________________________Blöcke erstellen_______________________________________________________________________________
	hashblocks=[[]]

	b=0 
	input.each do |x|
		if hashblocks[b].size < hashsize
			hashblocks[b].push(x)
		else
			hashblocks.push([])
			b+=1
			hashblocks[b].push(x)
		end
	end

#__________________________________Letzten Block mit Anfang des Inputs auffüllen__________________________________________________
	for x in 0..hashsize-hashblocks[b].size-1
		hashblocks[b].push(input[x%input.size])
	end

#__________________________________Blockzahl zu 10 auffüllen______________________________________________________________________
	blockcount=hashblocks.size
	for y in 0..10-blockcount do
		hashblocks.push(hashblocks[y])
	end

#__________________________________Blöcke rotieren________________________________________________________________________________
	hashblocks.each_with_index do |x, i|
		hashblocks[i]=x.rotate(i)
	end

#_____Blöcke intern mischen (Modulares Potenzieren, Modulare Addition, Kreuz- und "vorweg-greifende" Kombinationen, XORs, Rundenfaktoren)________________
	hashblocks.each_with_index do |x, i|
		x[(x[0]*i)%hashsize]=sqmul((x[2%hashsize]*input.size%hashsize).to_s(2), x[1], x[3%hashsize]+input.size%hashsize)   	#Modulares Potenzieren mit Mischen und Eingabegrößenfaktor
		for y in 0..hashsize-1
			cache=x[(y+2)%hashsize]										#y+2 Zwischenspeichern
			x[(y+2)%hashsize]=((x[y]+ x[(y+1)%hashsize])*input.size+i**2)%123				#Modulares, Kreuz-Addieren mit Rundenfaktor und Eingabegrößenfaktor
			x[y]=cache											#y tauschen durch Zwischenspeicher(y+2)
			x[y]=(x[(y)%hashsize] ^ x[(y+1)%hashsize]).to_s(2).to_i(2)					#Kreuzkombination (XORs)
		end
	end

#_________________________________Block 0 mit allen anderen mischen (XORs)________________________________________________________
	for x in 0..hashblocks.size-2 do
		for y in 0..hashsize-1
			hashblocks[0][y]=(hashblocks[0][y] ^ hashblocks[(x+1)][y]).to_s(2).to_i(2)
		end
	end

#_________________________________finales ascii Padding___________________________________________________________________________
	(hashblocks[0]).each_with_index do |x, i|
		hashblocks[0][i]=x%123
		if hashblocks[0][i]<48
			hashblocks[0][i]+=48
		elsif 90<hashblocks[0][i] && hashblocks[0][i]<97
			hashblocks[0][i]-=6
		elsif 57<hashblocks[0][i] && hashblocks[0][i]<65
			hashblocks[0][i]+=7
		end
	end

#_________________________________ascii zu Zeichen umwandeln und Ausgabe__________________________________________________________
	result=""
	hashblocks[0].each do |c|
		result+=c.chr
	end
	return result
end

=begin
password=eckisHashAlg(gets().chomp)
puts(password)
=end
