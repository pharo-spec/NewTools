Extension { #name : 'RPackage' }

{ #category : '*NewTools-ScopesBrowser' }
RPackage >> scopesIconName [
	^ #package
]

{ #category : '*NewTools-ScopesBrowser' }
RPackage >> subelements [
	^ self classes asOrderedCollection
]
