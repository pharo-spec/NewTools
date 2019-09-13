"
A FDGIFFilterTest is a test class for testing the behavior of FDGIFFilter
"
Class {
	#name : #FDGIFFilterTest,
	#superclass : #FDExtensionsFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDGIFFilterTest >> actualClass [
	^ FDGIFFilter
]

{ #category : #tests }
FDGIFFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'gif.gif')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
