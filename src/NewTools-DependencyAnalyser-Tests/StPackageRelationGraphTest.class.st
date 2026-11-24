Class {
	#name : 'StPackageRelationGraphTest',
	#superclass : 'TestCase',
	#instVars : [
		'packageCollectionAbstract',
		'packageCollectionsSequenceable',
		'packageKernel',
		'packageRegexCore',
		'packageStrings',
		'aPackageRelationGraph',
		'packagePackageDependencies',
		'packageA',
		'packageB',
		'packageC',
		'packageD',
		'packageTextCore',
		'packageOfTextMorph'
	],
	#category : 'NewTools-DependencyAnalyser-Tests-Packages',
	#package : 'NewTools-DependencyAnalyser-Tests',
	#tag : 'Packages'
}

{ #category : 'utilities' }
StPackageRelationGraphTest >> packageDependencyFrom: aPackage to: anOtherPackage [
	^ StPackageDependency from: aPackage to: anOtherPackage
]

{ #category : 'running' }
StPackageRelationGraphTest >> setUp [

	super setUp.
	aPackageRelationGraph := StPackageRelationGraph new.
	packageCollectionAbstract := StPackage onPackageNamed: 'Collections-Abstract'.
	packageStrings := StPackage onPackageNamed: 'Collections-Strings'.
	packageKernel := StPackage onPackageNamed: 'Kernel'.
	"Found through a class: Morphic's widgets package changes name"
	packageOfTextMorph := StPackage onPackageNamed: TextMorph package name.
	packageTextCore := StPackage onPackageNamed: 'Text-Core'.
	packageRegexCore := StPackage onPackageNamed: 'Regex-Core'.
	packageCollectionsSequenceable := StPackage onPackageNamed: 'Collections-Sequenceable'.
	packagePackageDependencies := StPackage onPackageNamed: #'NewTools-DependencyAnalyser'.
	packageA := StPackage onPackageNamed: 'A'.
	packageB := StPackage onPackageNamed: 'B'.
	packageC := StPackage onPackageNamed: 'C'.
	packageD := StPackage onPackageNamed: 'D'
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddExtensionDependencies [
	aPackageRelationGraph addExtensionDependencies: packageCollectionAbstract.
	"self assert: (packageStrings  dependentPackages includes: packageCollectionAbstract)."
	"self assert: (packageCollectionAbstract dependentPackages includes: packageKernel).
	self assert: (packageCollectionAbstract dependentPackages includes: packageRegexCore).
	self assert: (packageCollectionAbstract dependentPackages includes: packageCollectionsSequenceable)."
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddInheritanceDependencies [
	aPackageRelationGraph addInheritanceDependencies: packageCollectionAbstract.
	"Collections-Abstract has one dependency with Error and Object by Inheritance"
	self assert: (packageCollectionAbstract dependentPackages includes: packageKernel)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddPackage [
	self assertEmpty: aPackageRelationGraph packages.
	aPackageRelationGraph addPackage: packageCollectionAbstract.
	self assert: aPackageRelationGraph packages size equals: 1.
	aPackageRelationGraph addPackage: packageCollectionsSequenceable.
	self assert: aPackageRelationGraph packages size equals: 2
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddPackages [
	| array |
	self assertEmpty: aPackageRelationGraph packages.
	array := Array with: packageCollectionAbstract with: packageCollectionsSequenceable with: packageKernel.
	aPackageRelationGraph addPackages: array.
	self assert: aPackageRelationGraph packages size equals: 3
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddPoolDictionaryDependencies [

	aPackageRelationGraph addPoolDictionaryDependencies: packageOfTextMorph.

	self assert: (packageOfTextMorph dependentPackages includes: packageTextCore)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAddReferenceDependencies [
	aPackageRelationGraph addReferenceDependencies: packagePackageDependencies.
	packagePackageDependencies removeAllInternal.
	self assert: (packagePackageDependencies  dependentPackages includes: packageStrings)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAllDependentPackages [

		packageA add: (StPackageDependency from: packageA to: packageB)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAllDependentPackagesFromSeenPackages [
	packageA
		add: (self packageDependencyFrom: packageA to: packageB);
		add: (self packageDependencyFrom: packageA to: packageC).
	packageB add: (self packageDependencyFrom: packageB to: packageC).
	packageB add: (self packageDependencyFrom: packageB to: packageA).

	packageA beSeen.
	packageB beSeen.
	aPackageRelationGraph
		addPackage: packageA;
		addPackage: packageB.
	self assert: aPackageRelationGraph allDependentPackagesFromSeenPackages size equals: 3
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testAllSeen [
	aPackageRelationGraph addPackage: packageKernel.
	self deny: (aPackageRelationGraph allSeen).
	aPackageRelationGraph computeStaticDependencies.
	self deny: (aPackageRelationGraph allSeen)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testCanGetDaPackageFromAGivenClass [
	aPackageRelationGraph addPackage: packageCollectionAbstract.

	self
		assert: (aPackageRelationGraph packageForClass: Collection)
		equals: packageCollectionAbstract
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testClearAllDependencies [

	| aRelationGraph packagesFromGraph |
	aRelationGraph := StPackageRelationGraph onPackages:
		                  (#( 'Collections-Abstract' 'Collections-Sequenceable' ) collect: [ :each | StPackage onPackageNamed: each ]).
	aRelationGraph
		build;
		clearAllDependencies.
	packagesFromGraph := aRelationGraph seenPackages.
	self assert: (packagesFromGraph anySatisfy: [ :package | package dependencies isEmpty ])
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testCombineDependencies [
	| aSet |
	aSet := Set new.
	aPackageRelationGraph computeStaticDependencies:packageCollectionAbstract.
	packageCollectionAbstract removeAllInternal.
	"we collect all the target PDPackage"
	packageCollectionAbstract dependencies do: [ :dependency |
		aSet add: dependency target.
	  ].
	aPackageRelationGraph combineDependencies: packageCollectionAbstract.
	aSet do: [ :each | self assert: (packageCollectionAbstract dependentPackages includes: each) ]
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testComputeDependencies [
	aPackageRelationGraph computeStaticDependencies: packageCollectionAbstract.
	self deny: (packageCollectionAbstract dependencies isEmpty)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testDependenciesFrom [
	| aCollection |
	aCollection := OrderedCollection new.
	aCollection add: packageA.
	aCollection add: packageB.
	aCollection add: packageC.
	(aCollection at: 1) add: (StPackageDependency from: packageA to: packageB).
	(aCollection at: 1) add: (StPackageDependency from: packageA to: packageC).
	(aCollection at: 2) add: (StPackageDependency from: packageB to: packageC).
	aCollection do: [ :package | aPackageRelationGraph addPackage: package ].
	self assert: (aPackageRelationGraph dependenciesFrom: 'A') size equals: 2.
	self assert: (aPackageRelationGraph dependenciesFrom: 'B') size equals: 1.
	self assertEmpty: (aPackageRelationGraph dependenciesFrom: 'C')
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testIncludedPackages [
	| aCollection |
	aCollection := Bag new.
	"we add 2 packages in the relation"
	aCollection add: packagePackageDependencies.
	aCollection add: packageKernel.
	aCollection do: [ :each | aPackageRelationGraph addPackage: each ].
	self assert: aPackageRelationGraph includedPackages size equals: 2
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testPackageAt [

	aPackageRelationGraph addPackage: packageKernel.
	self assert: ( (aPackageRelationGraph packageAt: 'Kernel') isNotNil)
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testPackages [
	| aCollection |
	self assertEmpty: aPackageRelationGraph packages.
	aCollection := Bag new.
	aCollection add: packagePackageDependencies.
	aCollection add: packageKernel.
	aCollection do: [ :each | aPackageRelationGraph addPackage: each ].
	self assert: aPackageRelationGraph packages size equals: 2
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testPredecessors [
	| aCollection |
	"A -> B, C, D ; B -> D, C"
	aCollection := OrderedCollection new.
	aCollection add: packageA.
	aCollection add: packageB.
	aCollection add: packageC.
	aCollection add: packageD.
	packageA add: (StPackageDependency from: packageA to: packageB).
	packageA add: (StPackageDependency from: packageA to: packageC).
	packageA add: (StPackageDependency from: packageA to: packageD).
	packageB add: (StPackageDependency from: packageB to: packageC).
	packageB add: (StPackageDependency from: packageB to: packageD).
	aCollection do: [ :package | aPackageRelationGraph addPackage: package ].
	self assert: (aPackageRelationGraph predecessors: packageC) size equals: 2.
	self assertEmpty: (aPackageRelationGraph predecessors: (aCollection at: 1)).
	self assert: (aPackageRelationGraph predecessors: packageB) size equals: 1.
	self assert: (aPackageRelationGraph predecessors: packageD) size equals: 2
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testRemoveInternalDependencies [
	aPackageRelationGraph computeStaticDependencies.
	aPackageRelationGraph removeInternalDependencies.

	aPackageRelationGraph packages do: [ :value |
				value dependencies do:
					[ :dependency |
					self assert: (dependency isExternal).
					 ] ]
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testRemoveOutgoingDependencies [
	aPackageRelationGraph computeStaticDependencies.
	aPackageRelationGraph removeOutgoingDependencies.

	aPackageRelationGraph packages do: [ :package |
			package dependencies do: [ :dependency |
				self assert: (dependency target isIncluded)
				]
		 ]
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testRemovePackage [
	self assertEmpty: aPackageRelationGraph packages.
	aPackageRelationGraph addPackage: packageCollectionAbstract.
	self assert: aPackageRelationGraph packages size equals: 1.
	aPackageRelationGraph removePackage: packageCollectionAbstract packageName.
	self assertEmpty: aPackageRelationGraph packages
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testSeenPackages [
	aPackageRelationGraph addPackage: packageKernel.
	aPackageRelationGraph addPackage: packageCollectionAbstract.
	self assertEmpty: aPackageRelationGraph seenPackages.
	aPackageRelationGraph computeStaticDependencies.
	self assert: aPackageRelationGraph seenPackages size equals: 2
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testSeenPackagesName [
	aPackageRelationGraph addPackage: packageKernel.
	self deny: (aPackageRelationGraph seenPackagesName includes: 'Kernel').
	aPackageRelationGraph computeStaticDependencies.
	self assert: (aPackageRelationGraph seenPackagesName includes: 'Kernel')
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testSuccessors [
	| aCollection |
	"A -> B, C, D ; B -> D, C"
	aCollection := OrderedCollection new.
	aCollection add: packageA.
	aCollection add: packageB.
	aCollection add: packageC.
	aCollection add: packageD.
	packageA add: (StPackageDependency from: packageA to: packageB).
	packageA add: (StPackageDependency from: packageA to: packageC).
	packageA add: (StPackageDependency from: packageA to: packageD).
	packageB add: (StPackageDependency from: packageB to: packageC).
	packageB add: (StPackageDependency from: packageB to: packageD).
	aCollection do: [ :package | aPackageRelationGraph addPackage: package ].
	self assert: (aPackageRelationGraph successors: (aCollection at: 1)) size equals: 3.
	self assertEmpty: (aPackageRelationGraph successors: (aCollection at: 4)).
	self assert: (aPackageRelationGraph successors: (aCollection at: 2)) size equals: 2.
	self assertEmpty: (aPackageRelationGraph successors: (aCollection at: 3))
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testSystemPackageContaining [
	self assert: (aPackageRelationGraph systemPackageContaining: Collection) packageName equals: 'Collections-Abstract'.
	self assert: (aPackageRelationGraph systemPackageContaining: StPackageRelationGraph) packageName equals: #'NewTools-DependencyAnalyser'
]

{ #category : 'tests' }
StPackageRelationGraphTest >> testUsersOf [
	packageA
		add: (self packageDependencyFrom: packageA to: packageB);
		add: (self packageDependencyFrom: packageA to: packageC);
		beSeen.
	packageB
		add: (self packageDependencyFrom: packageA to: packageC);
		beSeen.

	aPackageRelationGraph
		addPackage: packageA;
		addPackage: packageB.

	self assert: (aPackageRelationGraph usersOf: packageC) size equals: 2.
	self assert: ((aPackageRelationGraph usersOf: packageC) includes: packageB)
]
