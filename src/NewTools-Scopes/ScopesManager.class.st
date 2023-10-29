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

{ #category : 'accessing' }
ScopesManager class >> defaultScopeLabel [

	^ 'Full environment'
]

{ #category : 'private' }
ScopesManager class >> fullPackagesFrom: classes [
	"packages whose classes were all selected"

	| theClasses packagesCache packages classesCache |
	theClasses := classes reject: [ :each | each isMeta ].
	
	packages := theClasses collect:[:class | class package].
	packagesCache := Dictionary new.
	packages do: [ :package | packagesCache at: package put: package definedClasses  ].
	classesCache := Dictionary new.
	theClasses do: [ :class | classesCache at: class put: class package ].
	^ packages select: [ :package |
		  package definedClasses size
		  = (theClasses select: [ :class | (classesCache at: class) = package ]) size ]
]

{ #category : 'accessing' }
ScopesManager class >> invalidNames [

	^ { self defaultScopeLabel }
	  , (self scopes collect: [ :e | e label ])
]

{ #category : 'operations' }
ScopesManager class >> newScopeFrom: aSet [

	| packageScope classScope classes packages orphanClasses fullPackages |
	classes := (aSet select: [ :each | each isClassOrTrait ]) reject: [
		           :each | each isMeta ].
	packages := aSet select: [ :each | each isKindOf: RPackage ].

	"packages whose classes were all selected"
	fullPackages := self fullPackagesFrom: classes.
	"classes whose package hasn't all of its classes selected"
	orphanClasses := self
		                 orphanClassesIn: classes
		                 havingFullPackages: fullPackages.

	classScope := RBClassEnvironment classes: orphanClasses.
	packageScope := RBPackageEnvironment packages: fullPackages.

	^ classScope | packageScope
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
	fullPackages := self fullPackagesFrom: classesInterAB.
	 
	^ self newScopeFrom: fullPackages , classesInterAB
]

{ #category : 'operations' }
ScopesManager class >> newScopeFromNot: scope [

	| classes rejectedFullPackages rejectedOrphanClasses rejectedClassesInFullPackages rejectedClasses acceptedPackages acceptedClasses |
	classes := scope classes.

	rejectedFullPackages := self fullPackagesFrom: classes.
	rejectedOrphanClasses := self
		                         orphanClassesIn: classes
		                         havingFullPackages: rejectedFullPackages.
	rejectedClassesInFullPackages := rejectedFullPackages collect: [
		                                 :each | each definedClasses ].
	rejectedClasses := rejectedOrphanClasses
	                   , rejectedClassesInFullPackages.

	acceptedPackages := self singleInstance allPackagesInEnvironment
		                    reject: [ :each |
		                    rejectedFullPackages includes: each name ].
	acceptedClasses := (self singleInstance allPackagesInEnvironment
		                    flatCollect: [ :each | each definedClasses ])
		                   reject: [ :each | rejectedClasses includes: each ].
	^ self newScopeFrom: acceptedPackages , acceptedClasses
]

{ #category : 'private' }
ScopesManager class >> orphanClassesIn: classes havingFullPackages: fullPackages [

	| theClasses packagesCache |
	theClasses := classes reject: [ :each | each isMeta ].
	packagesCache := Dictionary new.
	theClasses do: [ :each | packagesCache at: each put: each package ].
	^ theClasses reject: [ :class |
		  fullPackages includes: (packagesCache at: class) ]
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

	^ (environment current packages select: [ :package |
		   package definedClasses isNotEmpty ]) sorted
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

	^ self class defaultScopeLabel
]

{ #category : 'editing' }
ScopesManager >> editScope: aScope withNodes: aCollection [ 
	| classesInScope packagesInScope classes packages fullPackages orphanClasses addedClasses removedClasses addedPackages removedPackages |
	
	classesInScope := aScope classes.
	packagesInScope := aScope packages.
	
	classes := (aCollection select: [ :each | each isClassOrTrait ]) reject: [
		           :each | each isMeta ].
	classes := aScope classes asSet addAll: classes; yourself.
	
	packages := aCollection select: [ :each | each isKindOf: RPackage ].
	packages := aScope packages asSet addAll: packages; yourself.
	
	fullPackages := self fullPackagesFrom: classes.
	orphanClasses := self orphanClassesIn: classes havingFullPackages: fullPackages.
	
	addedClasses := orphanClasses reject: [ :aClass | classesInScope includes: aClass ].
	removedClasses := classesInScope reject: [ :aClass | orphanClasses includes: aClass ].
	
	addedPackages := fullPackages reject: [ :aPackage | packagesInScope includes: aPackage ].
	removedPackages := packagesInScope reject: [ :aPackage | fullPackages includes: aPackage ].
	
	addedClasses do: [ :aClass | aScope addClass: aClass ].
	removedClasses do: [ :aClass | aScope removeClass: aClass ].
	
	addedPackages do: [ :aPackage | aScope addPackage: aPackage name ].
	removedPackages do: [ :aPackage | aScope removePackage: aPackage name ].
	
	^ aScope
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
ScopesManager >> fullPackagesFrom: classes [ 
	^ self class fullPackagesFrom: classes
]

{ #category : 'initialization' }
ScopesManager >> initialize [

	environment ifNil: [ environment := SmalltalkImage ].
	scopes := Set new
]

{ #category : 'as yet unclassified' }
ScopesManager >> nameWithIndex: name [

	| existingNames index indexes |
	
	existingNames := self class invalidNames.

	index := ''.
	
	(existingNames includes: name) ifTrue: [
		indexes := existingNames
			           collect: [ :each |
				           index := (each reverse copyUpToSubstring: '-') reverse
					                    asInteger ]
			           thenReject: [ :each | each isNil ].
		index := indexes
			         ifEmpty: [ '-1' ]
			         ifNotEmpty: [ '-' , (indexes max + 1)  asString ] ].

	^ name, index asString
]

{ #category : 'private' }
ScopesManager >> newScopeFrom: aSetOfClassesAndPackages [

	^ self class newScopeFrom: aSetOfClassesAndPackages
]

{ #category : 'private' }
ScopesManager >> orphanClassesIn: classes havingFullPackages: fullPackages [

	^ self class
		  orphanClassesIn: classes
		  havingFullPackages: fullPackages
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
