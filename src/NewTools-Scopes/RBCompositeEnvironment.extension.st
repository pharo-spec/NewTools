Extension { #name : 'RBCompositeEnvironment' }

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> addClass: aClass [

	| envs classEnv packaEnv siblings |
	self isTerminal ifFalse: [
		self environment addClass: aClass.
		self otherEnvironment addClass: aClass.
		^ self ].

	"I am terminal. This method assumes that I have one classEnv and one packageEnv"
	envs := {
		        self environment.
		        self otherEnvironment }.

	classEnv := (envs select: [ :env | env isClassEnvironment ]) anyOne.
	packaEnv := (envs select: [ :env | env isPackageEnvironment ]) anyOne.

	"Get the classes in the same package as aClass (siblings)"
	siblings := classEnv classes select: [ :class |
		            class package = aClass package ].
	"If the package is now full, then add the package and remove the siblings"
	(siblings asSet add: aClass; yourself) size = (aClass package definedClasses size * 2) ifTrue: [
		siblings do: [ :each | classEnv removeClass: each ].
		packaEnv addPackage: aClass package.
		^ self ].

	classEnv addClass: aClass
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
RBCompositeEnvironment >> classesInHierarchies [
	self shouldBeImplemented.
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definedClasses [
	| definedClasses |
	definedClasses := IdentitySet new: 4096.
	self definedClassesDo: [ :each | each isMeta ifFalse: [definedClasses add: each] ].
	^ definedClasses
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> definedPackages [
	"Defined packages ignores packages got from extended classes"
	^ self definedClasses collect: [ :class | class package ]
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> fullPackages [
	
	"full packages are those where all classes belong to the scope (ignoring classes related to class hierarchy environments)"
	| classes classesInHierarchies |
	
	"classesInHierarchies := self classesInHierarchies.
	classes := self definedClasses reject: [ :class | classesInHierarchies includes: class ]."
	^ ScopesManager fullPackagesFrom: self definedClasses
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> orphanClasses [

	"orphan classes are those whose packages are not full packages"
	^ ScopesManager
		  orphanClassesIn: self definedClasses
		  havingFullPackages: self fullPackages
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removeClass: aClass [

	| envs  classEnv packaEnv packagesToRemove classesToAdd |
	self isTerminal ifFalse: [
		self environment removeClass: aClass.
		self otherEnvironment removeClass: aClass.
		^ self ].
	
	"I am terminal. This method assumes that I have one classEnv and one packageEnv"
	envs := { self environment . self otherEnvironment }.
	
	"Remove aClass from my classEnvironment"
	classEnv := (envs select: [ :env | env isClassEnvironment ]) anyOne.
	classEnv removeClass: aClass.
	
	packaEnv := (envs select: [ :env | env isPackageEnvironment ]) anyOne.
	
	"Packages containing aClass must be removed from the package environment"
	packagesToRemove := packaEnv packages select: [ :package | package definedClasses includes: aClass ].
	packagesToRemove do: [ :p | 
		packaEnv removePackage: p.
		classesToAdd := p definedClasses reject: [ :class | class = aClass ].
		classesToAdd do: [ :class | classEnv addClass: class ] ]
	
]

{ #category : '*NewTools-Scopes' }
RBCompositeEnvironment >> removePackage: aPackage [
	self environment removePackage: aPackage.
	self otherEnvironment removePackage: aPackage
]
