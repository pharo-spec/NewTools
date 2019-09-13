"
A FDNilFilterTest is a test class for testing the behavior of FDNilFilter
"
Class {
	#name : #FDNilFilterTest,
	#superclass : #FDAbstractFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDNilFilterTest >> actualClass [
	^ FDNilFilter
]

{ #category : #tests }
FDNilFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: root children
]
