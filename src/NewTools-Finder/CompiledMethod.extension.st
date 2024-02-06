Extension { #name : 'CompiledMethod' }

{ #category : '*NewTools-Finder' }
CompiledMethod >> selectorForFinder [
	"Answer a <Symbol> with the receiver's selector for the Finder tool"

	^ self selector.
]
