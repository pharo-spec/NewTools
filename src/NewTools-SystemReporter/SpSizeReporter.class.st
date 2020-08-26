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
SpSizeReporter >> reportLOC: aStream [
	| maniLoc testLoc baseLoc all|
	self header: 'Number of LinesOfCode' on: aStream.
	maniLoc := manifestClasses inject: 0 into: [ :sum :each | sum + each linesOfCode].
	testLoc := testClasses  inject: 0 into: [ :sum :each | sum + each linesOfCode].
	baseLoc := baselineOf inject: 0 into: [ :sum :each | sum + each linesOfCode].
	all := imageClasses inject: 0 into: [ :sum :each | sum + each linesOfCode].

	aStream nextPutAll: '#All classes: '.
	aStream print: all.
	aStream cr.
	aStream nextPutAll: '#Manifest classes: '.
	aStream print: maniLoc.
	aStream cr.
	aStream nextPutAll: '#Test classes: '.
	aStream print: testLoc.
	aStream cr.
	aStream nextPutAll: '#Baseline: '.
	aStream print: baseLoc.
	aStream cr.
	aStream nextPutAll: '#Effective classes: '.
	aStream print: all - baseLoc - testLoc - maniLoc .
	aStream cr.
	

]

{ #category : #'building report' }
SpSizeReporter >> reportNbClasses: aStream [

	self header: 'Number of classes' on: aStream.
	aStream 
		nextPutAll: 'All classes: ';
		nextPutAll: imageClasses size asString; cr ;
		nextPutAll: 'Tests: ' ;
		nextPutAll: testClasses size asString ; cr ;
		"very long to compute :-(
		nextPutAll: 'Without instances: ' ;
		nextPutAll: (imageClasses count: [:c | c allInstances isEmpty]) asString ; cr ;"
		nextPutAll: 'Manifests: ' ;
		nextPutAll: manifestClasses size asString; cr ;
		nextPutAll: 'BaselineOf-s: ' ;
		nextPutAll:  baselineOf size asString ; cr;
		nextPutAll: 'Effective classes: ';
		nextPutAll: (imageClasses size - testClasses size - manifestClasses size - baselineOf size) asString; cr.
		
		
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
