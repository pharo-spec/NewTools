"
A FDAbstractFilterTest is a test class for testing the behavior of FDAbstractFilter
"
Class {
	#name : 'StAbstractFilterTest',
	#superclass : 'StFileBrowserTestCase',
	#instVars : [
		'filter'
	],
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StAbstractFilterTest class >> isAbstract [
	^ self = StAbstractFilterTest
]

{ #category : 'accessing' }
StAbstractFilterTest >> actualClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
StAbstractFilterTest >> bananaJpg [
	^ root / 'banana.jpg'
]

{ #category : 'accessing' }
StAbstractFilterTest >> dir [
	^ root / 'dir'
]

{ #category : 'accessing' }
StAbstractFilterTest >> dirExt [
	^ root / 'dir.ext'
]

{ #category : 'instance creation' }
StAbstractFilterTest >> fileNamed: aString [
	^ FileSystem memory / aString
]

{ #category : 'accessing' }
StAbstractFilterTest >> hidden [
	^ root / '.hidden'
]

{ #category : 'accessing' }
StAbstractFilterTest >> hiddenDir [
	^ root / '.hidden-dir'
]

{ #category : 'accessing' }
StAbstractFilterTest >> patatePng [
	^ root / 'patate.png'
]

{ #category : 'running' }
StAbstractFilterTest >> setUp [
	super setUp.
	filter := self actualClass new
]

{ #category : 'accessing' }
StAbstractFilterTest >> sthAaa [
	^ root / 'sth.aaa'
]

{ #category : 'accessing' }
StAbstractFilterTest >> sthExt [
	^ root / 'sth.ext'
]

{ #category : 'tests' }
StAbstractFilterTest >> testPredicate [
	self subclassResponsibility
]
