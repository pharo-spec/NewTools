"
I am a class that is used to perform matches between pharo code and rewrite rules code.
"
Class {
	#name : 'StRewriterPatternMatcher',
	#superclass : 'Object',
	#category : 'NewTools-RewriterTools-Backend-Core',
	#package : 'NewTools-RewriterTools-Backend',
	#tag : 'Core'
}

{ #category : 'parsing' }
StRewriterPatternMatcher class >> parseCodeAST: code isForMethod: isForMethod [

	^ isForMethod
		ifTrue: [ OCParser parseMethod: code ]
		ifFalse: [ OCParser parseExpression: code ]
]

{ #category : 'parsing' }
StRewriterPatternMatcher class >> parsePatternAST: lhs isForMethod: isForMethod [

	^ isForMethod
		ifTrue: [ OCPatternParser parseMethod: lhs ]
		ifFalse: [ OCPatternParser parseExpression: lhs ]
]

{ #category : 'parsing' }
StRewriterPatternMatcher class >> performMatching: pharoCode pattern: lhs isForMethod: isForMethod [

	| matches astCode astPattern |
	matches := OrderedCollection new.

	astPattern := self parsePatternAST: lhs isForMethod: isForMethod.
	astCode := self parseCodeAST: pharoCode isForMethod: isForMethod.

	astCode doSemanticAnalysis.
	astCode nodesDo: [ :node |
		astPattern
			match: node
			onSuccess: [ :bindings | matches add: node -> bindings ]
			onFailure: [  ] ].

	^ matches
]
