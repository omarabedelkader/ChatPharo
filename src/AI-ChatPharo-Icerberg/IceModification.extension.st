Extension { #name : 'IceModification' }

{ #category : '*AI-ChatPharo-Icerberg' }
IceModification >> printOnLLMQuery: aWriteStream [

	| diffMorph diffs |
	diffMorph := DiffMorph
				 from: self oldDefinition contents
				 to: self definition contents.
	diffs := diffMorph allDifferences.
	diffs do: [ :diff |
		aWriteStream
			<< 'modification from:';
			<< String lf.
		aWriteStream
			<< (self oldDefinition contents
					 copyFrom: diff key first
					 to: diff key last);
			<< String lf.
		aWriteStream
			<< 'to:';
			<< String lf.
		aWriteStream
			<< (self definition contents
					 copyFrom: diff value first
					 to: diff value last);
			<< String lf ]
]
