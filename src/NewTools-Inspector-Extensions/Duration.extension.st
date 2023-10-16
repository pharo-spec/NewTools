Extension { #name : 'Duration' }

{ #category : '*NewTools-Inspector-Extensions' }
Duration >> inspectDurationIn: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Details'>
	
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #self value: self;
			key: #'human readable' value: self humanReadablePrintString;
			key: #days value: self days; 
			key: #hours value: self hours; 
			key: #minutes value: self minutes; 
			key: #seconds value: self seconds; 
			key: #nanoseconds value: self nanoSeconds; 
			table
]
