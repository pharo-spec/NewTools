Extension { #name : 'String' }

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionEncoding: specBuilder [
	<inspectorPresentationOrder: 200 title: 'Encoding'>
	| shorterString |

	shorterString := self truncateWithElipsisTo: 1000.
	^ (StSimpleInspectorBuilder on: specBuilder)
		key: #UTF8 value: shorterString utf8Encoded printString;
		key: #Latin1 value: ([shorterString encodeWith: #Latin1] on: Error do: [:ex | nil]) printString;
		table
]

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionFullString: aBuilder [
	<inspectorPresentationOrder: 100 title: 'Full Content'>
	
	^ aBuilder newCode
		addStyle: 'stCode';
		syntaxHighlight: false;
		text: self;
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
String >> inspectionString: aBuilder [
	<inspectorPresentationOrder: -10 title: 'Preview'>
	
	^ aBuilder newText
		text: (self truncateWithElipsisTo: 1000);
		yourself
]
