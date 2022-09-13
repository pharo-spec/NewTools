"
A FDHidenFilterTest is a test class for testing the behavior of FDHidenFilter
"
Class {
	#name : #StFBVisibleFilterTest,
	#superclass : #StFBAbstractFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBVisibleFilterTest >> actualClass [
	^ StFBVisibleFilter
]

{ #category : #tests }
StFBVisibleFilterTest >> testPredicate [

	Smalltalk os isWindows ifTrue: [ 
		self skip:
			'Too hard to make file hidden in Windows, do not test for it' ].

	self
		assertCollection: (filter applyOn: root children)
		hasSameElements: root children \ { 
				self hiddenDir.
				self hidden }
]
