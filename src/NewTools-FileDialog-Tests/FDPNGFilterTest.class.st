"
A FDPNGFilterTest is a test class for testing the behavior of FDPNGFilter
"
Class {
	#name : #FDPNGFilterTest,
	#superclass : #FDExtensionsFilterTest,
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #accessing }
FDPNGFilterTest >> actualClass [
	^ FDPNGFilter
]

{ #category : #tests }
FDPNGFilterTest >> testPredicate [
	self assert: (filter predicate: (self fileNamed: 'image.png')).
	self deny: (filter predicate: (self fileNamed: 'bitmap.bmp'))
]
