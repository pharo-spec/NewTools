"
A FDAbstractFilterTest is a test class for testing the behavior of FDAbstractFilter
"
Class {
	#name : #FDAbstractFilterTest,
	#superclass : #FDTestCase,
	#instVars : [
		'filter'
	],
	#category : #'NewTools-FileDialog-Tests-Filtering'
}

{ #category : #testing }
FDAbstractFilterTest class >> isAbstract [
	^ self = FDAbstractFilterTest
]

{ #category : #accessing }
FDAbstractFilterTest >> actualClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
FDAbstractFilterTest >> bananaJpg [
	^ root / 'banana.jpg'
]

{ #category : #accessing }
FDAbstractFilterTest >> dir [
	^ root / 'dir'
]

{ #category : #accessing }
FDAbstractFilterTest >> dirExt [
	^ root / 'dir.ext'
]

{ #category : #'instance creation' }
FDAbstractFilterTest >> fileNamed: aString [
	^ FileSystem memory / aString
]

{ #category : #accessing }
FDAbstractFilterTest >> hidden [
	^ root / '.hidden'
]

{ #category : #accessing }
FDAbstractFilterTest >> hiddenDir [
	^ root / '.hidden-dir'
]

{ #category : #accessing }
FDAbstractFilterTest >> patatePng [
	^ root / 'patate.png'
]

{ #category : #running }
FDAbstractFilterTest >> setUp [
	super setUp.
	filter := self actualClass new
]

{ #category : #accessing }
FDAbstractFilterTest >> sthAaa [
	^ root / 'sth.aaa'
]

{ #category : #accessing }
FDAbstractFilterTest >> sthExt [
	^ root / 'sth.ext'
]

{ #category : #tests }
FDAbstractFilterTest >> testPredicate [
	self subclassResponsibility
]
