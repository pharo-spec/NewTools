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
RBPackageEnvironment >> isPackageEnvironment [
	^ true
]

{ #category : '*NewTools-Scopes' }
RBPackageEnvironment >> removeClass: aClass [
	^ self
]
