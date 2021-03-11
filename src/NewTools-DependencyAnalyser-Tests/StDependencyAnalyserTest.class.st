Class {
	#name : #StDependencyAnalyserTest,
	#superclass : #TestCase,
	#category : #'NewTools-DependencyAnalyser-Tests'
}

{ #category : #tests }
StDependencyAnalyserTest >> testBuildRoots [

	StDANode buildForPackages: #('NewTools-DepencyAnalyser-Tests') 
]
