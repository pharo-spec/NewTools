Extension { #name : 'ClassDescription' }

{ #category : '*NewTools-ScopesBrowser' }
ClassDescription >> subelements [
	^ self protocols asOrderedCollection 
]
