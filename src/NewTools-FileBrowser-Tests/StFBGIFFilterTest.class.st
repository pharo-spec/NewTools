"
A FDGIFFilterTest is a test class for testing the behavior of FDGIFFilter
"
Class {
	#name : #StFBGIFFilterTest,
	#superclass : #StFBExtensionsFilterTest,
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #accessing }
StFBGIFFilterTest >> actualClass [
	^ StFBGIFFilter
]

{ #category : #tests }
StFBGIFFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'gif.gif')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
