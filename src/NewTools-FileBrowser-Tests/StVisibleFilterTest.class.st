"
A FDHidenFilterTest is a test class for testing the behavior of FDHidenFilter
"
Class {
	#name : 'StVisibleFilterTest',
	#superclass : 'StAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StVisibleFilterTest >> actualClass [
	^ StVisibleFilter
]

{ #category : 'tests' }
StVisibleFilterTest >> testPredicate [

	Smalltalk os isWindows 
		ifTrue: [ self skip: 'Too hard to make file hidden in Windows, do not test for it' ].

	self
		assertCollection: (filter applyOn: root children)
		hasSameElements: root children \ { 
				self hiddenDir.
				self hidden }
]
