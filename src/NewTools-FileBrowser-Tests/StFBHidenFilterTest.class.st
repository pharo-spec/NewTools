"
A FDHidenFilterTest is a test class for testing the behavior of FDHidenFilter
"
Class {
	#name : #StFBHidenFilterTest,
	#superclass : #StFBAbstractFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBHidenFilterTest >> actualClass [
	^ StFBVisibleFilter
]

{ #category : #tests }
StFBHidenFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: root children \ {self hiddenDir . self hidden}
]
