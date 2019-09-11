"
A FDBitmapFilterTest is a test class for testing the behavior of FDBitmapFilter
"
Class {
	#name : #FDBitmapFilterTest,
	#superclass : #FDExtensionsFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDBitmapFilterTest >> actualClass [
	^ FDBitmapFilter
]

{ #category : #tests }
FDBitmapFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'bitmap.bmp')).
	self assert: (filter predicate: (self fileNamed: 'bitmap.dib')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
