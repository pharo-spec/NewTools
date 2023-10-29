Extension { #name : 'RBCompositeEnvironment' }

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> addClass: aClass [
	self environment addClass: aClass.
	self otherEnvironment addClass: aClass
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removeClass: aClass [
	self environment removeClass: aClass.
	self otherEnvironment removeClass: aClass
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removePackage: aPackage [
	self environment removePackage: aPackage.
	self otherEnvironment removePackage: aPackage
]
