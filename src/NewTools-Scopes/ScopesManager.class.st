"
I store and manage user created scopes
"
Class {
	#name : 'ScopesManager',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'environment',
		'announcer',
		'defaultScope'
	],
	#classVars : [
		'singleInstance'
	],
	#category : 'NewTools-Scopes-Core',
	#package : 'NewTools-Scopes',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScopesManager class >> addScope: aScope [
	self singleInstance addScope: aScope
]

{ #category : 'accessing' }
ScopesManager class >> availableScopes [

	^ self scopes
]

{ #category : 'private' }
ScopesManager class >> fullPackagesIn: packages having: classes [
	"packages whose classes were all selected"

	^ packages select: [ :package |
		  | packCheckedClasses |
		  packCheckedClasses := classes select: [ :class |
			                        class package == package ].
		  package definedClasses size == packCheckedClasses size ]
]

{ #category : 'accessing' }
ScopesManager class >> invalidNames [
	^ self scopes collect: [ :e | e label ]
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: aSet [

	| packageScope classScope classes packages orphanClasses fullPackages compositeScope |
	classes := (aSet select: [ :each | each isClassOrTrait ]) reject: [ :each | each isMeta ] .
	packages := aSet select: [ :each | each isKindOf: RPackage ].

	"packages whose classes were all selected"
	fullPackages := self fullPackagesIn: packages having: classes.
	"classes whose package hasn't all of its classes selected"
	orphanClasses := self
		                 orphanClassesIn: classes
		                 havingPackages: packages
		                 fullPackages: fullPackages.

	classScope := RBClassEnvironment classes: orphanClasses.
	packageScope := RBPackageEnvironment packages: fullPackages.

	(classScope isNotEmpty and: [ packageScope isNotEmpty ]) ifTrue: [
		compositeScope := packageScope | classScope ].

	compositeScope ifNotNil: [ ^ compositeScope ].
	packageScope isEmpty ifFalse: [ ^ packageScope ].
	classScope isEmpty ifFalse: [ ^ classScope ].
	self error: 'Impossible to create scope from nodes'
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: scopeA and: scopeB [

	| classesA classesB classesInterAB packages fullPackages |
	
	classesA := scopeA classes asSet.
	classesB := scopeB classes.
	
	classesInterAB := (classesA, classesB) select: [ :each |
		                   (classesA includes: each) and: [
			                   classesB includes: each ] ].
	packages := classesInterAB collect: [ :each  | each package ].
	fullPackages := self fullPackagesIn: packages having: classesInterAB.
	 
	^ self newScopeFrom: fullPackages , classesInterAB
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: scopeA or: scopeB [
	^ self newScopeFrom: scopeA classes, scopeB classes, scopeA packages, scopeB packages
]

{ #category : 'operations' }
ScopesManager class >> newScopeFromNot: scope [
	self halt.
]

{ #category : 'private' }
ScopesManager class >> orphanClassesIn: classes havingPackages: packages fullPackages: fullPackages [

	| classesInFullPackages |
	classesInFullPackages := fullPackages flatCollect: [ :package |
		                         package definedClasses ].
	^ classes reject: [ :class | classesInFullPackages includes: class ]
]

{ #category : 'accessing' }
ScopesManager class >> removeScope: aScope [
	self singleInstance removeScope: aScope
]

{ #category : 'accessing' }
ScopesManager class >> reset [
	<script>
	singleInstance ifNotNil: [ singleInstance reset ].
	singleInstance := nil
]

{ #category : 'accessing' }
ScopesManager class >> scopes [
	^ self singleInstance scopes asArray
]

{ #category : 'accessing' }
ScopesManager class >> singleInstance [

	^ singleInstance ifNil: [
		  singleInstance := self basicNew
			                    environment: SmalltalkImage;
			                    initialize;
			                    yourself ]
]

{ #category : 'api' }
ScopesManager >> addScope: aScope [
	(scopes includes: aScope) ifTrue: [ ^ self ].
	scopes add: aScope
]

{ #category : 'accessing' }
ScopesManager >> allPackagesInEnvironment [

	^ environment current packages select: [ :package | package definedClasses isNotEmpty ]
]

{ #category : 'accessing' }
ScopesManager >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'api' }
ScopesManager >> defaultScope [

	^ defaultScope ifNil: [
		  defaultScope := (self scopeClass packages:
			                   self allPackagesInEnvironment) label:
			                  self defaultScopeLabel ]
]

{ #category : 'accessing' }
ScopesManager >> defaultScopeLabel [

	^ 'Full environment'
]

{ #category : 'api' }
ScopesManager >> environment [

	^ environment
]

{ #category : 'api' }
ScopesManager >> environment: aSmalltalkImage [

	environment := aSmalltalkImage
]

{ #category : 'private' }
ScopesManager >> fullPackagesIn: packages having: classes [ 
	^ self class fullPackagesIn: packages having: classes 
]

{ #category : 'initialization' }
ScopesManager >> initialize [

	environment ifNil: [ environment := SmalltalkImage ].
	scopes := Set new
]

{ #category : 'private' }
ScopesManager >> newScopeFrom: aSetOfClassesAndPackages [

	^ self class newScopeFrom: aSetOfClassesAndPackages
]

{ #category : 'private' }
ScopesManager >> orphanClassesIn: classes havingPackages: packages fullPackages: fullPackages [ 
	^ self class orphanClassesIn: classes havingPackages: packages fullPackages: fullPackages 
]

{ #category : 'removing' }
ScopesManager >> removeScope: aRBEnvironment [
	| removed |
	removed := scopes select: [ :scope | scope label = aRBEnvironment label ].
	removed do: [ :scope | scopes remove: scope ]
]

{ #category : 'initialization' }
ScopesManager >> reset [

	environment := nil.
	self announcer subscriptions reset.
	defaultScope := nil.
	scopes := #(  )
]

{ #category : 'running' }
ScopesManager >> scopeClass [
	^ RBPackageEnvironment 
]

{ #category : 'accessing' }
ScopesManager >> scopes [

	^ scopes
]
