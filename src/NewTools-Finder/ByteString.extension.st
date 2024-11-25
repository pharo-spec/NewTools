Extension { #name : 'ByteString' }

{ #category : '*NewTools-Finder' }
ByteString class >> allSelectorsToTestInMethodFinderWithArity: anInteger [
	"Returns all the selectors with a certain arity which are approved by the class so which can be tested in the Method Finder."

	^  self allSelectorsToTestInMethodFinder select: [ :selector | selector numArgs = anInteger ]
]
