Extension { #name : 'ByteArray' }

{ #category : '*NewTools-Inspector-Extensions' }
ByteArray >> inspectBytes: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Bytes'>

	^ self size > 1000 
		ifTrue: [
			(StSimpleInspectorBuilder on: specBuilder)
				key: 'error' value: 'too many bytes, size is ' , self size asString;
				table ]
		ifFalse: [ self inspectBytesBody: specBuilder ]
]

{ #category : '*NewTools-Inspector-Extensions' }
ByteArray >> inspectBytesBody: specBuilder [
		^ (StSimpleInspectorBuilder on: specBuilder)
				key: 'hex string' value: (String streamContents: [ :out | 
					self do: [ :each | each printOn: out base: 16 nDigits: 2 ] ]);
				key: 'hex lines' value: (String streamContents: [ :out |
					self withIndexDo: [ :each :index |
						index = 1 ifFalse: [ 
							index - 1 \\ 8 = 0 ifTrue: [ out cr ] ifFalse: [ out space ] ].
						each printOn: out base: 16 nDigits: 2 ] ]);
				key: #UTF8 value: ([ self utf8Decoded ] on: ZnCharacterEncodingError do: [ :exception | exception ]);
				key: #Latin1 value: ([ self decodeWith: #Latin1 ] on: ZnCharacterEncodingError do: [ :exception | exception ]);
				key: 'integer' value: self asInteger;
				key: 'integer reversed' value: self reversed asInteger;
				table
]
