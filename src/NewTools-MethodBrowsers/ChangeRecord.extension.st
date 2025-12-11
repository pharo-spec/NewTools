Extension { #name : 'ChangeRecord' }

{ #category : '*NewTools-MethodBrowsers' }
ChangeRecord >> asRingDefinition [
	"Retrieves a RGMethodDefinition object based on the data of the receiver"

	self type == #method
		ifTrue: [ ^self createMethodDefinition ].
	self type == #classComment
		ifTrue: [ ^self createCommentDefinition ].
	^nil
]

{ #category : '*NewTools-MethodBrowsers' }
ChangeRecord >> createCommentDefinition [
	"Retrieves a RGCommentDefinition object based on the data of the receiver"

	^ (RGCommentDefinition class: self commentClass)
		content: self string;
		stamp: stamp;
		yourself
]

{ #category : '*NewTools-MethodBrowsers' }
ChangeRecord >> createMethodDefinition [
	"Retrieves a RGMethodDefinition object based on the data of the receiver"

	^(RGMethodDefinition named: self methodSelector)
		parentName: self methodClassName;
		isMeta: meta;
		sourceCode: self string;
		protocol: protocol;
		stamp: stamp;
		yourself
]
