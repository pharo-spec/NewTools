"
A FDGIFFilterTest is a test class for testing the behavior of FDGIFFilter
"
Class {
	#name : 'StGIFFilterTest',
	#superclass : 'StExtensionsFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StGIFFilterTest >> actualClass [
	^ StFBGIFFilter
]

{ #category : 'tests' }
StGIFFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'gif.gif')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
