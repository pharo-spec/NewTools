Extension { #name : #FBLocation }

{ #category : #'*FlagBrowser-Spec' }
FBLocation >> openInBrowser [
	Smalltalk tools browser openOnMethod: self compiledMethod
]
