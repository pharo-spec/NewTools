Class {
	#name : #StDAPackageRelationGraphTest,
	#superclass : #TestCase,
	#category : #'NewTools-DependencyAnalyser-Tests'
}

{ #category : #tests }
StDAPackageRelationGraphTest >> testBuild [
	| graph |
	
	graph := 	(DAPackageRelationGraph onPackagesNamed: #('NewTools-Core')) build.
	self denyEmpty: graph packages.
	self denyEmpty: (graph packages select: [ :each | each packageName beginsWith: 'Spec2' ])
]

{ #category : #tests }
StDAPackageRelationGraphTest >> testPackageAsDependentPackageWrapperOn [
	| graph wrapped |

	self flag: #TODO. "Rename 
		#asDependentPackageWrapperOn: to 
		#asDependentPackageInGraph:
		(And also its class)"	
	graph := 	(DAPackageRelationGraph onPackagesNamed: #('NewTools-Core')) build.
	self denyEmpty: graph packages.
	
	wrapped := graph packages 
		collect: [ :each | each asDependentPackageWrapperOn: graph ].

	self denyEmpty: wrapped.
]
