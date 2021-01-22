Extension { #name : #CompiledMethod }

{ #category : #'*NewTools-Spotter-Extensions' }
CompiledMethod >> spotterPreview: aBuilder [

	^ aBuilder newCode
		beForMethod: self;
		beNotEditable;
		text: self sourceCode;
		yourself
]
