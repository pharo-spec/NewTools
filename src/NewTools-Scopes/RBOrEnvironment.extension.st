Extension { #name : 'RBOrEnvironment' }

{ #category : '*NewTools-Scopes' }
RBOrEnvironment >> definedClassesDo: aBlock [
	| enumerated |
	enumerated := IdentitySet new.
	environment definedClassesDo: [ :each |
		aBlock value: each.
		enumerated add: each].
	self orEnvironment definedClassesDo: [ :each |
		(enumerated includes: each)
			ifFalse: [ aBlock value: each ] ]
]

{ #category : '*NewTools-Scopes' }
RBOrEnvironment >> isTerminal [

	^ (environment isClassEnvironment or: [
		   environment isPackageEnvironment ]) and: [
		  otherEnvironment isClassEnvironment or: [
			  otherEnvironment isPackageEnvironment ] ]
]
