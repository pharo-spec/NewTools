Extension { #name : 'Time' }

{ #category : '*NewTools-Inspector-Extensions' }
Time >> inspectTimeIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Details'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #iso value: self print24;
			key: #hours value: self hours; 
			key: #minutes value: self minutes; 
			key: #seconds value: self seconds; 
			key: #nanoseconds value: self nanoSecond; 
			key: #meridian value: self meridianAbbreviation; 
			table
]
