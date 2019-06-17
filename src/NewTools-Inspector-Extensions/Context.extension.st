Extension { #name : #Context }

{ #category : #'*NewTools-Inspector-Extensions' }
Context >> contextInspection [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: -1>
	^ StContextInspection on: self
]
