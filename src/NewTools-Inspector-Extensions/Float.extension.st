Extension { #name : 'Float' }

{ #category : '*NewTools-Inspector-Extensions' }
Float >> inspectFloatIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Float'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #binary value: self binaryLiteralString;
			key: #significand value: self significand;
			key: #exponent value: self exponent;
			table
]
