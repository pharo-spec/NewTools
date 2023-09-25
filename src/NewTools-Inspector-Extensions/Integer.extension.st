Extension { #name : 'Integer' }

{ #category : '*NewTools-Inspector-Extensions' }
Integer >> inspectIntegerIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Integer'> 
	
	| inspectorBuilder |
	(inspectorBuilder := StSimpleInspectorBuilder on: specBuilder) 
		key: #self value: self;
		key: #decimal value: self printString;
		key: 	#hex value: self printStringHex;
		key: #octal value: (self printStringBase: 8);
		key: 	#binary value: (self printStringBase: 2).
	(self between: 0 and: ZnCharacterEncoder default maximumUTFCode)	
		ifTrue: [ inspectorBuilder key: #character value: self asCharacter ].
	^ inspectorBuilder table
]
