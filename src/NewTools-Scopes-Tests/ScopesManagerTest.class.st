Class {
	#name : 'ScopesManagerTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Scopes-Tests',
	#package : 'NewTools-Scopes-Tests'
}

{ #category : 'private' }
ScopesManagerTest >> scopesManagerClass [
	^ ScopesManager
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassOrPackageScopeAddingClass [
	| scope oldElements newElements |
	" A `ClassOrPackage` scope is a composite environment of a class environment and a package environment "
	oldElements := { ScClassA1 . ScClassB1 package } asSet.
	
	scope := self scopesManagerClass newScopeFrom: oldElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: {ScClassA1} asSet.
	
	newElements := { ScClassA1 . ScClassA2 . ScClassB1 package } asSet.
	self scopesManagerClass editScope: scope withNodes: newElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: {ScClassA1 . ScClassA2} asSet
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassOrPackageScopeAddingClassAndCompletingFullPackage [
	| scope oldElements newElements |
	oldElements := { ScClassA1 . ScClassA2 . ScClassB1 package } asSet.
	
	scope := self scopesManagerClass newScopeFrom: oldElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: {ScClassA1 . ScClassA2} asSet.
	
	newElements := { ScClassA1 . ScClassA2 . ScClassA3 . ScClassB1 package } asSet.
	self scopesManagerClass editScope: scope withNodes: newElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: { ScClassA1 . ScClassA2 . ScClassA3 } asSet
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassOrPackageScopeRemovingClass [
	| scope oldElements newElements |
	oldElements := { ScClassA1 . ScClassA2 . ScClassB1 package } asSet.
	
	scope := self scopesManagerClass newScopeFrom: oldElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: {ScClassA1 . ScClassA2} asSet.
	
	newElements := { ScClassA1 . ScClassB1 package } asSet.
	self scopesManagerClass editScope: scope withNodes: newElements.
	self assert: scope fullPackages equals: {ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: { ScClassA1 } asSet
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassOrPackageScopeRemovingClassAndBreakingFullPackage [
	| scope oldElements newElements |
	oldElements := { ScClassA1 package . ScClassB1 package } asSet.
	
	scope := self scopesManagerClass newScopeFrom: oldElements.
	self assert: scope fullPackages equals: {ScClassA1 package . ScClassB1 package} asSet.
	self assert: scope orphanClasses equals: Set new.
	
	newElements := { ScClassA1 . ScClassA2 . ScClassB1 package } asSet.
	self scopesManagerClass editScope: scope withNodes: newElements.
	self assert: scope fullPackages equals: { ScClassB1 package } asSet.
	self assert: scope orphanClasses equals: { ScClassA1 . ScClassA2 } asSet
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassScopeAddingClass [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 . ScClassA2 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: newClasses
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassScopeAddingClassAndCompletingFullPackage [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 . ScClassA2 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages isEmpty.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 . ScClassA2 . ScClassA3 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages isEmpty.
	self assert: scope orphanClasses equals: newClasses
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassScopeRemovingClass [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 . ScClassA2 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: newClasses.
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditClassScopeRemovingClassAndBreakingFullPackage [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 . ScClassA2 . ScClassA3 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages isEmpty.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 . ScClassA2 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages isEmpty.
	self assert: scope orphanClasses equals: newClasses.
	
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromAPackageWithExtendedClasses [
	| packages scope |
	packages := { ScClassC package } asSet.
	scope := self scopesManagerClass newScopeFrom: packages.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope fullPackages asSet equals: packages.
	self assert: scope definedClasses equals: (packages flatCollect: [ :p | p definedClasses ]).
	self assert: scope orphanClasses isEmpty
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASetOfClasses [
	| classes scope |
	classes := { ScClassA1 . ScClassA2 .ScClassA3 . ScClassB1 } asSet.
	scope := self scopesManagerClass newScopeFrom: classes.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope fullPackages isEmpty.
	self assert: scope orphanClasses equals: classes
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASetOfPackages [
	| packages scope |
	packages := { ScClassA1 package . ScClassB1 package } asSet.
	scope := self scopesManagerClass newScopeFrom: packages.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope definedClasses equals: (packages flatCollect: [ :p | p definedClasses ]).
	self assert: scope fullPackages equals: packages.
	self assert: scope orphanClasses equals: Set new
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASinglePackageAndItsClasses [
	| classes scope packages packageAndItsClasses |
	classes := { ScClassA1 . ScClassA2 .ScClassA3 } asSet.
	packages := { ScClassA1 package } asSet.
	packageAndItsClasses := Set newFrom: classes.
	packageAndItsClasses addAll: packages.
	
	scope := self scopesManagerClass newScopeFrom: packageAndItsClasses.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope definedClasses equals: classes.
	self assert: scope fullPackages equals: packages.
	self assert: scope orphanClasses asSet equals: Set new
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASinglePackageAndSomeOfItsClasses [
	| classes scope packages packageAndItsClasses |
	classes := { ScClassA1 . ScClassA2 } asSet.
	packages := { ScClassA1 package } asSet.
	packageAndItsClasses := Set newFrom: classes.
	packageAndItsClasses addAll: packages.
	
	scope := self scopesManagerClass newScopeFrom: packageAndItsClasses.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope definedPackages asSet equals: packages.
	self assert: scope definedClasses equals: ScClassA1 package definedClasses.
	self assert: scope orphanClasses asSet equals: Set new
]
