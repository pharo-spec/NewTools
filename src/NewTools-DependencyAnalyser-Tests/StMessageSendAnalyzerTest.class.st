Class {
	#name : 'StMessageSendAnalyzerTest',
	#superclass : 'TestCase',
	#instVars : [
		'analyzer'
	],
	#category : 'NewTools-DependencyAnalyser-Tests-Core',
	#package : 'NewTools-DependencyAnalyser-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
StMessageSendAnalyzerTest >> setUp [
	super setUp.
	analyzer := StMessageSendAnalyzer on: 'NewTools-DependencyAnalyser-Tests-Data'
]

{ #category : 'tests' }
StMessageSendAnalyzerTest >> testShouldFindDependencyWhenUnimplementedCalls [
	self
		assert: analyzer missingMethods size
		equals: 3
]

{ #category : 'tests' }
StMessageSendAnalyzerTest >> testShouldGetPotentialMatchForUnimplementedCalls [

	self
		assert: (analyzer missingMethodsWithPotentialMatch values collect: [:each | each size])
		equals: #(0 2 10).
	self
		assert: (analyzer missingMethodsWithPotentialMatchAfterManuallyResolvedDependenciesAddition values collect: #size)
		equals: #(0 2 10)
]

{ #category : 'tests' }
StMessageSendAnalyzerTest >> testSystemPackage [

	self assert: analyzer systemPackage class equals: Package.
	analyzer := StMessageSendAnalyzer on: 'Unloaded-Dummy-Package'.
	self
		assert: analyzer systemPackage class = Package
		description: 'It test that rPackage still answer a Package even when the analyzer was instantiated with an unexisting or unloaded package'.
	self assertEmpty: analyzer systemPackage definedClasses
]

{ #category : 'tests' }
StMessageSendAnalyzerTest >> testSystemPackageIsAnsweredWithLoadedPackage [

	self assertCollection: analyzer systemPackage definedClasses hasSameElements: { StSomeClass }
]
