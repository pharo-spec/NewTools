"
A FDJPEGFilterTest is a test class for testing the behavior of FDJPEGFilter
"
Class {
	#name : #FDJPEGFilterTest,
	#superclass : #FDExtensionsFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDJPEGFilterTest >> actualClass [
	^ FDJPEGFilter
]

{ #category : #tests }
FDJPEGFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'image.jpeg')).
	self assert: (filter predicate: (self fileNamed: 'image.jpg')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.png'))
]
