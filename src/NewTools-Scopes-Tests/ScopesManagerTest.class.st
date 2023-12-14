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
ScopesManagerTest >> testEditScopeAddingClass [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 . ScClassA2 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: newClasses.
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditScopeAddingClassAndCompletingFullPackage [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 . ScClassA2 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: oldClasses.
		
	newClasses := { ScClassA1 . ScClassA2 . ScClassA3 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages equals: {ScClassA1 package} asSet.
	self assert: scope orphanClasses equals: Set new.
	
]

{ #category : 'private' }
ScopesManagerTest >> testEditScopeRemovingClass [
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
ScopesManagerTest >> testEditScopeRemovingClassAndBreakingFullPackage [
	| scope oldClasses newClasses |
	oldClasses := { ScClassA1 . ScClassA2 . ScClassA3 } asSet.
	scope := self scopesManagerClass newScopeFrom: oldClasses.
	self assert: scope fullPackages equals: {ScClassA1 package} asSet.
	self assert: scope orphanClasses equals: Set new.
		
	newClasses := { ScClassA1 . ScClassA2 } asSet.
	self scopesManagerClass editScope: scope withNodes: newClasses.
	self assert: scope fullPackages equals: Set new.
	self assert: scope orphanClasses equals: newClasses.
	
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromAPackageWithExtendedClasses [
	| packages scope |
	packages := { ScClassC package } asSet.
	scope := self scopesManagerClass newScopeFrom: packages.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope definedPackages asSet equals: packages.
	self assert: scope definedClasses equals: (packages flatCollect: [ :p | p definedClasses ]).
	self assert: scope fullPackages equals: packages.
	self assert: scope orphanClasses equals: Set new
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASetOfClasses [
	| classes scope |
	classes := { ScClassA1 . ScClassA2 .ScClassA3 . ScClassB1 } asSet.
	scope := self scopesManagerClass newScopeFrom: classes.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope packages asSet equals: { ScClassA1 package . ScClassB1 package } asSet.
	self assert: scope definedClasses equals: classes.
	self assert: scope fullPackages equals: { ScClassA1 package } asSet.
	self assert: scope orphanClasses asSet equals: { ScClassB1 } asSet
]

{ #category : 'tests' }
ScopesManagerTest >> testNewScopeFromASetOfPackages [
	| packages scope |
	packages := { ScClassA1 package . ScClassB1 package } asSet.
	scope := self scopesManagerClass newScopeFrom: packages.
	"new scopes are always RBOrEnvironments"
	self assert: scope isCompositeEnvironment.
	self assert: scope packages asSet equals: packages.
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
	self assert: scope packages asSet equals: packages.
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
	self assert: scope fullPackages equals: packages.
	self assert: scope orphanClasses asSet equals: Set new
]
