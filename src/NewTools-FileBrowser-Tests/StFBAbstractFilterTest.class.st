"
A FDAbstractFilterTest is a test class for testing the behavior of FDAbstractFilter
"
Class {
	#name : #StFBAbstractFilterTest,
	#superclass : #StFBTestCase,
	#instVars : [
		'filter'
	],
	#category : #'NewTools-FileBrowser-Tests-Filtering'
}

{ #category : #testing }
StFBAbstractFilterTest class >> isAbstract [
	^ self = StFBAbstractFilterTest
]

{ #category : #accessing }
StFBAbstractFilterTest >> actualClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
StFBAbstractFilterTest >> bananaJpg [
	^ root / 'banana.jpg'
]

{ #category : #accessing }
StFBAbstractFilterTest >> dir [
	^ root / 'dir'
]

{ #category : #accessing }
StFBAbstractFilterTest >> dirExt [
	^ root / 'dir.ext'
]

{ #category : #'instance creation' }
StFBAbstractFilterTest >> fileNamed: aString [
	^ FileSystem memory / aString
]

{ #category : #accessing }
StFBAbstractFilterTest >> hidden [
	^ root / '.hidden'
]

{ #category : #accessing }
StFBAbstractFilterTest >> hiddenDir [
	^ root / '.hidden-dir'
]

{ #category : #accessing }
StFBAbstractFilterTest >> patatePng [
	^ root / 'patate.png'
]

{ #category : #running }
StFBAbstractFilterTest >> setUp [
	super setUp.
	filter := self actualClass new
]

{ #category : #accessing }
StFBAbstractFilterTest >> sthAaa [
	^ root / 'sth.aaa'
]

{ #category : #accessing }
StFBAbstractFilterTest >> sthExt [
	^ root / 'sth.ext'
]

{ #category : #tests }
StFBAbstractFilterTest >> testPredicate [
	self subclassResponsibility
]
