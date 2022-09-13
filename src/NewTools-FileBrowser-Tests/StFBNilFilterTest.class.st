"
A FDNilFilterTest is a test class for testing the behavior of FDNilFilter
"
Class {
	#name : #StFBNilFilterTest,
	#superclass : #StFBAbstractFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBNilFilterTest >> actualClass [
	^ StFBAllFilter
]

{ #category : #tests }
StFBNilFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: root children
]
