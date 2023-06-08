"
I am a cache for the critiques, false positives critiques and to-do critiques.

"
Class {
	#name : #CBCritiquesCache,
	#superclass : #Object,
	#instVars : [
		'critiques',
		'toDos',
		'falsePositives',
		'checker',
		'browser',
		'falsePositiveRules',
		'falsePositiveClasses',
		'packages',
		'change'
	],
	#category : #'NewTools-CodeCritiques-Utilities'
}

{ #category : #private }
CBCritiquesCache >> addAllCritiqueToFalsePositive: aCollectionOfCritique forRule: aRule on: aManifestBuilder [

	| ruleId versionId critiquess |
	critiquess := aCollectionOfCritique reject: [ :c | 
		              falsePositiveClasses includes:
			              c criticTheNonMetaclassClass ].
	ruleId := aRule class uniqueIdentifierName.
	versionId := aRule class identifierMinorVersionNumber.
	(aManifestBuilder hasFalsePositiveOf: ruleId version: versionId) 
		ifFalse: [ 
		aManifestBuilder installFalsePositiveOf: ruleId version: versionId ].
	aManifestBuilder
		addAllFalsePositive: critiquess
		of: ruleId
		version: versionId
]

{ #category : #private }
CBCritiquesCache >> addAllCritiqueToToDo: aCollectionOfCritique forRule: aRule on: aManifestBuilder [

	| ruleId versionId |
	ruleId := aRule class uniqueIdentifierName.
	versionId := aRule class identifierMinorVersionNumber.
	(aManifestBuilder hasToDoOf: ruleId version: versionId) ifFalse: [ 
		aManifestBuilder installToDoOf: ruleId version: versionId ].
	aManifestBuilder
		addAllToDo: aCollectionOfCritique
		of: ruleId
		version: versionId
]

{ #category : #'add/remove' }
CBCritiquesCache >> addCritique: aCritique forRule: aRule [

	(critiques includesKey: aRule) ifFalse: [ 
		critiques at: aRule put: IdentitySet new ].
	(critiques at: aRule) add: aCritique.
	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> addFalsePositive: aCritique forRule: aRule [

	(falsePositives includesKey: aRule) ifFalse: [ 
		falsePositives at: aRule put: IdentitySet new ].
	(falsePositives at: aRule) add: aCritique.
	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> addFalsePositiveClass: aClass [

	| fp |
	falsePositiveClasses add: aClass instanceSide.
	critiques keysAndValuesDo: [ :rule :critiquess | 
		fp := critiquess select: [ :critique | 
			      aClass = critique criticTheNonMetaclassClass ].
		fp do: [ :each | self addFalsePositive: each forRule: rule ] ].
	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> addFalsePositiveRule: aRule forPackage: aPackage [

	| fp |
	(falsePositiveRules includesKey: aPackage) ifFalse: [ 
		falsePositiveRules at: aPackage put: Set new ].
	(falsePositiveRules at: aPackage) add:
		aRule class uniqueIdentifierName.
	fp := (critiques at: aRule ifAbsent: [ ^ self ]) select: [ :c | 
		      (self packageOf: c) package name = aPackage packageName ].
	fp do: [ :c | self addFalsePositive: c forRule: aRule ]
]

{ #category : #'add/remove' }
CBCritiquesCache >> addToDo: aCritique forRule: aRule [

	(toDos includesKey: aRule) ifFalse: [ 
		toDos at: aRule put: IdentitySet new ].
	(toDos at: aRule) add: aCritique.
	self updateBrowser
]

{ #category : #accessing }
CBCritiquesCache >> browser: aCodeCritiicBrowser [
	browser := aCodeCritiicBrowser 
]

{ #category : #private }
CBCritiquesCache >> builderManifestClass [
	^ TheManifestBuilder
]

{ #category : #accessing }
CBCritiquesCache >> cacheChange [
	^ change
]

{ #category : #private }
CBCritiquesCache >> cacheChanged [ 
	change := true
]

{ #category : #private }
CBCritiquesCache >> cacheNotChanged [ 
	change := false
]

{ #category : #accessing }
CBCritiquesCache >> checker: aSmallLintChercker [
	checker := aSmallLintChercker
]

{ #category : #protocol }
CBCritiquesCache >> critiquesOf: aRule [

	aRule ifNil: [ ^ {  } ].
	^ aRule isComposite
		  ifTrue: [ 
		  aRule rules flatCollect: [ :rule | self critiquesOf: rule ] ]
		  ifFalse: [ critiques at: aRule ifAbsent: [ {  } ] ]
]

{ #category : #protocol }
CBCritiquesCache >> falsePositiveOf: aRule [
	
	aRule ifNil: [ ^ {}].
	^ aRule isComposite
		ifTrue: [ aRule rules flatCollect: [ :rule | self falsePositiveOf: rule ]]
		ifFalse: [ falsePositives at: aRule ifAbsent: [ {} ]]
	
	
]

{ #category : #initialization }
CBCritiquesCache >> initCache [

	checker rule do: [ :rule | 
		falsePositives
			at: rule
			put: (IdentitySet newFrom: (checker falsePositiveOf: rule)).
		toDos at: rule put: (IdentitySet newFrom: (checker toDoOf: rule)).
		critiques
			at: rule
			put: (IdentitySet newFrom: (checker criticsOf: rule)) ].
	packages do: [ :package | 
		falsePositiveRules
			at: package
			put: (checker rejectRulesOf: package) asSet.
		falsePositiveClasses addAll:
			(checker rejectClassesOf: package) asIdentitySet ]
]

{ #category : #initialization }
CBCritiquesCache >> initialize [

	super initialize.
	falsePositives := Dictionary new.
	toDos := Dictionary new.
	critiques := Dictionary new.
	falsePositiveRules := Dictionary new.
	falsePositiveClasses := IdentitySet new.
	change := false
]

{ #category : #testing }
CBCritiquesCache >> isFalsePositive: aCritique forRule: aRule [
	^ (self falsePositiveOf: aRule) includes: aCritique
]

{ #category : #testing }
CBCritiquesCache >> isToDo: aCritique forRule: aRule [
	^ (self toDosOf: aRule) includes: aCritique
]

{ #category : #'add/remove' }
CBCritiquesCache >> itemRemoved: anItem [

	{ 
		critiques.
		toDos.
		falsePositives } do: [ :ruleDict | 
		ruleDict valuesDo: [ :crits | 
			crits removeAllSuchThat: [ :crit | 
				crit sourceAnchor entity = anItem ] ] ]
]

{ #category : #private }
CBCritiquesCache >> logFalsePositiveClassInManifest [
	| manifestBuilder |
	packages
		do: [ :package | 
			manifestBuilder := self builderManifestClass ofPackageNamed: package packageName.
			manifestBuilder rejectClasses \ falsePositiveClasses do: [ :cl | manifestBuilder removeRejectClass: cl ].
			falsePositiveClasses \ manifestBuilder rejectClasses do: [ :cl | manifestBuilder addRejectClass: cl ] ]
]

{ #category : #private }
CBCritiquesCache >> logFalsePositiveInManifest [

	| removeFp addFp |
	falsePositives keysAndValuesDo: [ :rule :critiquess | 
		removeFp := (checker falsePositiveOf: rule) \ critiquess.
		removeFp := removeFp collect: [ :c | c sourceAnchor entity ].
		addFp := critiquess \ (checker falsePositiveOf: rule).
		addFp := addFp collect: [ :c | c sourceAnchor entity ].
		(removeFp groupedBy: [ :each | self builderManifestClass of: each ]) 
			keysAndValuesDo: [ :manifestBuilder :value | 
				self
					removeAllCritiqueToFalsePositive: value
					forRule: rule
					on: manifestBuilder ].
		(addFp groupedBy: [ :each | self builderManifestClass of: each ]) 
			keysAndValuesDo: [ :manifestBuilder :value | 
				(manifestBuilder rejectRules includes:
					 rule class uniqueIdentifierName) ifFalse: [ 
					self
						addAllCritiqueToFalsePositive: value
						forRule: rule
						on: manifestBuilder ] ] ]
]

{ #category : #private }
CBCritiquesCache >> logFalsePositiveRulesInManifest [
	| manifestBuilder |
	falsePositiveRules
		keysAndValuesDo: [:package :rules | 
			manifestBuilder := self builderManifestClass ofPackageNamed: package packageName.
			manifestBuilder rejectRules \ rules do: [ :rule | manifestBuilder removeRejectRule: rule ].
			rules \ manifestBuilder rejectRules do: [ :rule | manifestBuilder addRejectRule: rule ]]
]

{ #category : #protocol }
CBCritiquesCache >> logInManifest [

	self cacheChange 
		ifFalse: [^ self].
	self logFalsePositiveRulesInManifest.
	self logFalsePositiveClassInManifest.
	self logFalsePositiveInManifest.
	self logToDosInManifest.
	self cacheNotChanged. 		
	self initCache
	
]

{ #category : #private }
CBCritiquesCache >> logToDosInManifest [

	| removeFp addFp |
	toDos keysAndValuesDo: [ :rule :critiquess | 
		removeFp := (checker toDoOf: rule) \ critiquess.
		removeFp := removeFp collect: [ :c | c sourceAnchor entity ].
		addFp := critiquess \ (checker toDoOf: rule).
		addFp := addFp collect: [ :c | c sourceAnchor entity ].
		(removeFp groupedBy: [ :each | self builderManifestClass of: each ]) 
			keysAndValuesDo: [ :manifestBuilder :value | 
				self
					removeAllCritiqueToToDo: value
					forRule: rule
					on: manifestBuilder ].
		(addFp groupedBy: [ :each | self builderManifestClass of: each ]) 
			keysAndValuesDo: [ :manifestBuilder :value | 
				(manifestBuilder rejectRules includes:
					 rule class uniqueIdentifierName) ifFalse: [ 
					self
						addAllCritiqueToToDo: value
						forRule: rule
						on: manifestBuilder ] ] ]
]

{ #category : #private }
CBCritiquesCache >> packageOf: aCritc [
	^ aCritc mcWorkingCopy 
]

{ #category : #accessing }
CBCritiquesCache >> packages: aPackageEnv [
	
	packages := aPackageEnv packages
]

{ #category : #private }
CBCritiquesCache >> removeAllCritiqueToFalsePositive: aCollectionOfCritique forRule: aRule on: aManifestBuilder [

	| ruleId versionId |
	ruleId := aRule class uniqueIdentifierName.
	versionId := aRule class identifierMinorVersionNumber.
	(aManifestBuilder hasFalsePositiveOf: ruleId version: versionId) 
		ifTrue: [ 
			aManifestBuilder
				removeAllFalsePositive: aCollectionOfCritique
				of: ruleId
				version: versionId ]
]

{ #category : #private }
CBCritiquesCache >> removeAllCritiqueToToDo: aCollectionOfCritique forRule: aRule on: aManifestBuilder [

	| ruleId versionId |
	ruleId := aRule class uniqueIdentifierName.
	versionId := aRule class identifierMinorVersionNumber.
	(aManifestBuilder hasToDoOf: ruleId version: versionId) ifTrue: [ 
		aManifestBuilder
			removeAllToDo: aCollectionOfCritique
			of: ruleId
			version: versionId ]
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeCritique: aCritique forRule: aRule [

	(critiques includesKey: aRule) ifFalse: [ ^ self ].
	(critiques at: aRule) remove: aCritique ifAbsent: [ ^ self ].
	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeFalsePositive: aCritique forRule: aRule [

	(falsePositives includesKey: aRule) 
		ifFalse: [^ self ].
	[ (falsePositiveClasses includes: aCritique sourceAnchor entity criticTheNonMetaclassClass) 
			ifTrue: [^ self] ]
		on: MessageNotUnderstood 
		do: [ ^ self "#criticTheNonMetaclassClass makes no sense on a Package, ignore"].
	(falsePositives at: aRule) remove: aCritique ifAbsent: [^ self].
	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeFalsePositiveClass: aClass [

	| fp |
	falsePositiveClasses remove: aClass ifAbsent: [ ^ self ].
	critiques keysAndValuesDo: [ :rule :critiquess | 
		fp := critiquess select: [ :critique | 
			      aClass = critique criticTheNonMetaclassClass ].
		fp do: [ :each | self removeFalsePositive: each forRule: rule ] ]
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeFalsePositiveRule: aRule forPackage: aPackage [

	| fp |
	(falsePositiveRules includesKey: aPackage) ifFalse: [ ^ self ].

	(falsePositiveRules at: aPackage)
		remove: aRule class uniqueIdentifierName
		ifAbsent: [ ^ self ].

	fp := (critiques at: aRule ifAbsent: [ ^ self ]) select: [ :c | 
		      (self packageOf: c) package name = aPackage packageName and: [ 
			      (falsePositiveClasses includes: c criticTheNonMetaclassClass)
				      not ] ].
	fp do: [ :c | self removeFalsePositive: c forRule: aRule ].

	self updateBrowser
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeRule: aRule [

	{ 
		critiques.
		toDos.
		falsePositives } do: [ :ruleDict | ruleDict removeKey: aRule ]
]

{ #category : #'add/remove' }
CBCritiquesCache >> removeToDo: aCritique forRule: aRule [

	(toDos includesKey: aRule) 
		ifFalse: [^ self].
			
	(toDos at:aRule) remove: aCritique ifAbsent: [^ self].
	self updateBrowser
	
]

{ #category : #protocol }
CBCritiquesCache >> replaceAll: oldMethod by: newMethod [

	critiques valuesDo: [ :each | 
		(each includes: oldMethod) ifTrue: [ 
			each remove: oldMethod.
			each add: newMethod ] ].

	falsePositives valuesDo: [ :each | 
		(each includes: oldMethod) ifTrue: [ 
			each remove: oldMethod.
			each add: newMethod ] ].

	toDos valuesDo: [ :each | 
		(each includes: oldMethod) ifTrue: [ 
			each remove: oldMethod.
			each add: newMethod ] ]
]

{ #category : #protocol }
CBCritiquesCache >> toDosOf: aRule [

	aRule ifNil: [ ^{} ].
	^ aRule isComposite
		ifTrue: [ aRule rules flatCollect: [:rule | self toDosOf: rule ]]
		ifFalse: [toDos at: aRule ifAbsent: [ {} ]]
]

{ #category : #private }
CBCritiquesCache >> updateBrowser [

	self cacheChanged.
	browser updateTree 
]
