Extension { #name : 'IceAddition' }

{ #category : '*AI-ChatPharo-Icerberg' }
IceAddition >> printOnLLMQuery: aWriteStream [

	aWriteStream
		<< 'addition';
		<< String lf.
	aWriteStream << self leftContents
]
