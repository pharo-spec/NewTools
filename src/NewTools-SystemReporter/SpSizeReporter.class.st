"
I'm a reporter dedicated to size of the system.

```
SpSizeReporter new openWithSpec
```
"
Class {
	#name : #SpSizeReporter,
	#superclass : #SpReporter,
	#instVars : [
		'imageClasses',
		'manifestClasses',
		'testClasses',
		'baselineOf'
	],
	#category : #'NewTools-SystemReporter'
}

{ #category : #initialization }
SpSizeReporter >> initialize [ 
	super initialize.
	imageClasses := self class environment allClasses.
	manifestClasses := imageClasses select: [ :each | each isManifest ].
	testClasses := imageClasses select: [ :each | each isTestCase ].
	baselineOf := imageClasses select: [:c | c name beginsWith: 'BaselineOf' ].
]

{ #category : #'building report' }
SpSizeReporter >> printNumber: aNumber on: aStream [

	aNumber
		printSeparatedBy: Character space 
		every: 3
		signed: false
		on: aStream
]

{ #category : #'building report' }
SpSizeReporter >> reportLOC: aStream [
	| maniLoc testLoc baseLoc all|
	self header: 'Number of LinesOfCode' on: aStream.
	maniLoc := manifestClasses inject: 0 into: [ :sum :each | sum + each linesOfCode].
	testLoc := testClasses  inject: 0 into: [ :sum :each | sum + each linesOfCode].
	baseLoc := baselineOf inject: 0 into: [ :sum :each | sum + each linesOfCode].
	all := imageClasses inject: 0 into: [ :sum :each | sum + each linesOfCode].

	aStream nextPutAll: '#All classes: '.
	self printNumber: all on: aStream.
	aStream cr.
	aStream nextPutAll: '#Manifest classes: '.
	self printNumber: maniLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '#Test classes: '.
	self printNumber: testLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '#Baseline: '.
	self printNumber: baseLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '#Effective classes: '.
	self printNumber: all - baseLoc - testLoc - maniLoc on: aStream.
	aStream cr.
	

]

{ #category : #'building report' }
SpSizeReporter >> reportNbClasses: aStream [

	self header: 'Number of classes' on: aStream.
	aStream nextPutAll: '# classes: '.
	self printNumber: imageClasses size on: aStream.
	aStream cr; nextPutAll: '# Tests classes: '.
	self printNumber: testClasses size on: aStream.
	aStream cr; nextPutAll: '# Manifest classes: '.
	self printNumber: manifestClasses size on: aStream.
	aStream cr; nextPutAll: '# BaselineOf-s:  '.
	self printNumber: baselineOf size on: aStream.
	aStream cr; nextPutAll: '# Test classes: '.
	self printNumber: testClasses size on: aStream.
	aStream cr; nextPutAll: '# Effective classes:  '.
	self printNumber: (imageClasses size - testClasses size - manifestClasses size - baselineOf size) on: aStream.
		
		
]

{ #category : #'building report' }
SpSizeReporter >> reportNbTraits: aStream [
	| imageTraits |
	imageTraits := Smalltalk allTraits.
	self header: 'Number of traits' on: aStream.
	aStream 
		nextPutAll: imageTraits size asString; cr ;
		nextPutAll: 'not used: ' ;
		nextPutAll: (imageTraits count: [ :t | t users isEmpty ]) asString; cr

]

{ #category : #ui }
SpSizeReporter >> title [ 

	^ 'Size reporter'
]

{ #category : #initialization }
SpSizeReporter >> topicSpec [
	| topics |
	topics := OrderedCollection new.
	topics addAll:  {
		#'# classes' -> #reportNbClasses:  .
		#'# traits' -> #reportNbTraits: .
		#'Total LOC' -> #reportLOC:
		}.
	^ topics
		 
]
