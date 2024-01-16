"
A FDPNGFilterTest is a test class for testing the behavior of FDPNGFilter
"
Class {
	#name : 'StPNGFilterTest',
	#superclass : 'StExtensionsFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StPNGFilterTest >> actualClass [
	^ StFBPNGFilter
]

{ #category : 'tests' }
StPNGFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'image.png')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.bmp'))
]
