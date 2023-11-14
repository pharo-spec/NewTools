Extension { #name : 'CompiledMethod' }

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterForBytecodesFor: aStep [
	<stSpotterOrder: 15>
	
	aStep listProcessor
		title: 'Bytecode';
		allCandidates: [ self symbolicBytecodes ];
		itemName: #printString;
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterForImplementorsFor: aStep [
	<stSpotterOrder: 10>
	
	aStep listProcessor
			title: 'Implementors';
			allCandidates: [ self implementors collect: [:each | each compiledMethod] ];
			filter: StFilterSubstring;
			keyBinding: $m command
]

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterForSendersFor: aStep [
	<stSpotterOrder: 11>
	aStep listProcessor
			title: 'Senders';
			allCandidates: [ self senders collect: [:each | each compiledMethod] ];
			filter: StFilterSubstring;
			keyBinding: $n command
]

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterMethodClassFor: aStep [
	<stSpotterOrder: 50>

	aStep listProcessor
			allCandidates: [  {self methodClass }];
			title: 'Class';
			filter: StFilterSubstring;
			itemIconName: [ :item | item systemIconName ]
]

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterPreview: aBuilder [

	^ aBuilder newCode
		beForMethod: self;
		beNotEditable;
		text: self sourceCode;
		yourself
]

{ #category : '*NewTools-Spotter-Extensions' }
CompiledMethod >> stActDefault [
	^ self browse
]
