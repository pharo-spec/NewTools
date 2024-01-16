"
A FDJPEGFilterTest is a test class for testing the behavior of FDJPEGFilter
"
Class {
	#name : 'StJPEGFilterTest',
	#superclass : 'StExtensionsFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StJPEGFilterTest >> actualClass [
	^ StFBJPEGFilter
]

{ #category : 'tests' }
StJPEGFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'image.jpeg')).
	self assert: (filter predicate: (self fileNamed: 'image.jpg')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
