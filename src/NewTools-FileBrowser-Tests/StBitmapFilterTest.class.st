"
A FDBitmapFilterTest is a test class for testing the behavior of FDBitmapFilter
"
Class {
	#name : 'StBitmapFilterTest',
	#superclass : 'StExtensionsFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StBitmapFilterTest >> actualClass [
	^ StFBBitmapFilter
]

{ #category : 'tests' }
StBitmapFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'bitmap.bmp')).
	self assert: (filter predicate: (self fileNamed: 'bitmap.dib')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
