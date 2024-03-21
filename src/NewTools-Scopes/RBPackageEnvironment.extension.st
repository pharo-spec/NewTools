Extension { #name : 'RBPackageEnvironment' }

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> addClass: aClass [
	^ self
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> asScopeNode [

	^ ScopePackageNode on: self
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> definedClassesDo: aBlock [ 
	| enumerated enumerator |
	enumerated := IdentitySet new.
	enumerator := [ :each |
		(enumerated includes: each) ifFalse: [
			(environment includesClass: each)
				ifTrue: [ aBlock value: each ].
			(environment includesClass: each classSide)
				ifTrue: [ aBlock value: each classSide].
			enumerated add: each ] ].
	packages do: [ :package |
		package definedClasses do: enumerator ]
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> isPackageEnvironment [
	^ true
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> orphanClasses [
	^ Set new
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> removeClass: aClass [
	^ self
]
