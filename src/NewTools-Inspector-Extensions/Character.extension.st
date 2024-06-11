Extension { #name : 'Character' }

{ #category : '*NewTools-Inspector-Extensions' }
Character >> inspectCharacterIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Character'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #codepoint value: self codePoint;
			key: #unicode value: (String streamContents: [ :stream | 
				stream << 'U+'.
				self codePoint printOn: stream base: 16 nDigits: 4 ]);
			table
]
