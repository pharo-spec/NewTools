"
A FDBitmapFilterTest is a test class for testing the behavior of FDBitmapFilter
"
Class {
	#name : #StFBBitmapFilterTest,
	#superclass : #StFBExtensionsFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBBitmapFilterTest >> actualClass [
	^ StFBBitmapFilter
]

{ #category : #tests }
StFBBitmapFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'bitmap.bmp')).
	self assert: (filter predicate: (self fileNamed: 'bitmap.dib')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
