"
A FDNilFilterTest is a test class for testing the behavior of FDNilFilter
"
Class {
	#name : 'StNilFilterTest',
	#superclass : 'StAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StNilFilterTest >> actualClass [
	^ StFBAllFilter
]

{ #category : 'tests' }
StNilFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: root children
]
