"
A FDDirectoryFilterTest is a test class for testing the behavior of FDDirectoryFilter
"
Class {
	#name : #FDDirectoryFilterTest,
	#superclass : #FDAbstractFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDDirectoryFilterTest >> actualClass [
	^ FDDirectoryFilter
]

{ #category : #tests }
FDDirectoryFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: {self dir . self dirExt . self hiddenDir}
]
