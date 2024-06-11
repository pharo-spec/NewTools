Extension { #name : 'String' }

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionEncoding: specBuilder [
	<inspectorPresentationOrder: 200 title: 'Encoding'>
	
	| shorterString |
	shorterString := self truncateWithElipsisTo: 1000.
	^ (StSimpleInspectorBuilder on: specBuilder)
			key: #UTF8 value: shorterString utf8Encoded printString;
			key: #Latin1 value: (shorterString encodeWith: #Latin1) printString;
			table
]

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionFullString [
	<inspectorPresentationOrder: 100 title: 'Full Content'>
	^ SpCodePresenter new
		syntaxHighlight: false;
		text: self;
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionString [
	<inspectorPresentationOrder: -10 title: 'Preview'>
	
	^ SpTextPresenter new
		text: (self truncateWithElipsisTo: 1000);
		yourself
]
