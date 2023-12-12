Extension { #name : 'RBOrEnvironment' }

{ #category : '*NewTools-Scopes' }
RBOrEnvironment >> isTerminal [

	^ (environment isClassEnvironment or: [
		   environment isPackageEnvironment ]) and: [
		  otherEnvironment isClassEnvironment or: [
			  otherEnvironment isPackageEnvironment ] ]
]
