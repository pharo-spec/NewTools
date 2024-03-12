Extension { #name : 'RBCompositeEnvironment' }

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> addClass: aClass [

	self classEnvironment addClass: aClass
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> addPackage: aPackage [

	self environment addPackage: aPackage.
	self otherEnvironment addPackage: aPackage
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> asScopeNode [

	^ ScopeScopeNode on: self
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> classEnvironment [
	^ environment
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> classesInHierarchies [
	self shouldBeImplemented.
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definedClasses [
	| definedClasses |
	definedClasses := IdentitySet new: 4096.
	self definedClassesDo: [ :each | each isMeta ifFalse: [definedClasses add: each] ].
	^ definedClasses reject: [ :each | each isMeta ]
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definedClassesDo: aBlock [
	| enumerated |
	enumerated := IdentitySet new.
	self classEnvironment definedClassesDo: [ :each |
		aBlock value: each.
		enumerated add: each].
	self packageEnvironment definedClassesDo: [ :each |
		(enumerated includes: each)
			ifFalse: [ aBlock value: each ] ]
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definedPackages [

	^ self packageEnvironment packages
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definesPackageNamed: aPackageName [

	^ (self definedPackages collect: [ :p | p name ]) includes:
		  aPackageName
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> orphanClasses [

	"orphan classes are those whose packages are not in the scope"
	^ ScopesManager
		  orphanClassesIn: self definedClasses
		  havingFullPackages: self definedPackages
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> packageEnvironment [
	^ otherEnvironment
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removeAllDefinedClasses [
	self definedClasses do: [ :class | self removeClass: class ]
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removeAllDefinedPackages [
	self definedPackages do: [ :package | self removePackage: package ]
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removeClass: aClass [

	self classEnvironment removeClass: aClass
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removePackage: aPackage [
	self environment removePackage: aPackage.
	self otherEnvironment removePackage: aPackage
]
