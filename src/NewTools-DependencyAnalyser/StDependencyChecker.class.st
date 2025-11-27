"
Utility class to easily check  dependencies of packages.


DADependencyChecker new dependenciesOf: #CargoPackageManager.

DADependencyChecker new transitiveDependenciesOf: #'CargoPackageManager-Minimal'.

DADependencyChecker new dependentsOf: #CargoPackageManager.
"
Class {
	#name : 'StDependencyChecker',
	#superclass : 'Object',
	#instVars : [
		'report',
		'shouldComputeMessageSendDependencies'
	],
	#category : 'NewTools-DependencyAnalyser-Report',
	#package : 'NewTools-DependencyAnalyser',
	#tag : 'Report'
}

{ #category : 'private' }
StDependencyChecker >> buildPackageRelationGraphFor: aPackageName [
	^ [ (StPackageRelationGraph onPackagesNamed: { aPackageName })
		 	shouldComputeMessageSendDependencies: self shouldComputeMessageSendDependencies;
			build ]
		on: StPotentialOutDatedDependencyWarning
		do: [ :ex | report addWarning: ex. ex resume ]
]

{ #category : 'private' }
StDependencyChecker >> computeDependenciesOf: aPackageName [

	| dependencies |
	dependencies := (self daPackageFor: aPackageName) dependentPackages collect: [ :each | each packageName ].
	^ (dependencies
		   addAll: (self manuallyResolvedDependenciesOf: aPackageName);
		   yourself) sorted
]

{ #category : 'private' }
StDependencyChecker >> computeDependenciesOf: aPackageName visitedPackages: visited [
	| packageName |
	packageName := aPackageName asSymbol.
	report
			add: packageName
			dependencies: (self computeDependenciesOf: packageName).
	visited add: packageName
]

{ #category : 'computing - dependencies' }
StDependencyChecker >> computeImageDependencies [

	| visited |
	self newReport.
	report
		analysisRunString: 'Pharo image dependencies';
		imageVersion: SystemVersion current.
	visited := Set new.
	self packageOrganizer packageNames do: [ :packageName | self computeDependenciesOf: packageName visitedPackages: visited ].
	^ report
]

{ #category : 'private' }
StDependencyChecker >> computeTransitiveDependenciesOf: aPackageName visitedPackages: visited [
	(visited includes: aPackageName) ifTrue: [ ^ self ].
	self computeDependenciesOf: aPackageName visitedPackages: visited.
	(self dependenciesOf: aPackageName)
		do: [ :each | self computeTransitiveDependenciesOf: each visitedPackages: visited ]
]

{ #category : 'private' }
StDependencyChecker >> daPackageFor: aPackageName [

	^ ((self buildPackageRelationGraphFor: aPackageName) packages select: #isSeen) first
]

{ #category : 'accessing' }
StDependencyChecker >> dependenciesOf: aPackageName [
	^ report
		dependenciesOf: aPackageName asSymbol
		ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'initialization' }
StDependencyChecker >> initialize [
	super initialize.
	self newReport
]

{ #category : 'private' }
StDependencyChecker >> manuallyResolvedDependenciesOf: aPackageName [
	^ (self packageOrganizer packageNamed: aPackageName) manuallyResolvedDependencies
]

{ #category : 'initialization' }
StDependencyChecker >> newReport [
	^ report := StDependencyReport new
]

{ #category : 'computing - dependencies' }
StDependencyChecker >> shortestPathToPackageIntroducingDependency: dependencyPackageName startingFrom: aPackageName [
	"This method allows to easily spots a package dependency we want to avoid in the System.
	ex: DADependencyChecker new
			computeImageDependencies;
			shortestPathToPackageIntroducingDependency: #'Athens-Core' startingFrom: 'Monticello'.
	The answer will be the shortest path (one, not all) going from #Monticello to #'Athens-Core',
	showing dependencies that leads to the introduction of the  #'Athens-Core' dependency.
		=> #(#Monticello #Kernel #'System-Settings-Core' #'Morphic-Widgets-Windows' #'Rubric' #'Athens-Morphic' #'Athens-Core').
	Now, we know that System-Settings-Core brings the whole graphical environment with him and that we should avoid the dependency
	between #Kernel and #'System-Settings-Core'."
	| dijkstra |
	report ifNil: [ ^ self ].
	dijkstra := AIDijkstra new.
	dijkstra nodes: report dependencies keys.
	report dependenciesDo: [ :packageName :dependencies |
		dependencies do: [ :dependency |
			dijkstra edges: { packageName } from: [ :ignored | packageName ] to: [ :ignored | dependency ] ] ].
	dijkstra runFrom: aPackageName to: dependencyPackageName.
	^ dijkstra reconstructPath
]

{ #category : 'accessing' }
StDependencyChecker >> shouldComputeMessageSendDependencies [
	^ shouldComputeMessageSendDependencies ifNil: [ true ]
]

{ #category : 'accessing' }
StDependencyChecker >> shouldComputeMessageSendDependencies: aBoolean [
	shouldComputeMessageSendDependencies := aBoolean 
]

{ #category : 'computing - dependencies' }
StDependencyChecker >> transitiveDependenciesOf: aPackageName [
	self newReport.
	report
		analysisRunString: 'Transitive dependencies of ' , aPackageName;
		imageVersion: SystemVersion current.
	self computeTransitiveDependenciesOf: aPackageName visitedPackages: Set new.
	^ report
]

{ #category : 'accessing' }
StDependencyChecker >> unresolvedDependenciesOf: aPackageName [
	^ [ (StMessageSendAnalyzer on: aPackageName) missingMethodsWithPotentialMatchAfterManuallyResolvedDependenciesAddition
		reject: #isEmpty ]
		on: StPotentialOutDatedDependencyWarning
		do: [ :ex | ex resume ]
]
