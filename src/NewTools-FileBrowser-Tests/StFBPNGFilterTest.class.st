"
A FDPNGFilterTest is a test class for testing the behavior of FDPNGFilter
"
Class {
	#name : #StFBPNGFilterTest,
	#superclass : #StFBExtensionsFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBPNGFilterTest >> actualClass [
	^ StFBPNGFilter
]

{ #category : #tests }
StFBPNGFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'image.png')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.bmp'))
]
