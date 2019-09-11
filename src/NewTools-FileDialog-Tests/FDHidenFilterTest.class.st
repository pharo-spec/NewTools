"
A FDHidenFilterTest is a test class for testing the behavior of FDHidenFilter
"
Class {
	#name : #FDHidenFilterTest,
	#superclass : #FDAbstractFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDHidenFilterTest >> actualClass [
	^ FDVisibleFilter
]

{ #category : #tests }
FDHidenFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: root children \ {self hiddenDir . self hidden}
]
