Extension { #name : #FBFlagLocation }

{ #category : #'*FlagBrowser-Spec' }
FBFlagLocation >> openInBrowser [
	Smalltalk tools browser openOnMethod: self compiledMethod
]
