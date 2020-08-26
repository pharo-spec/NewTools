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
		'imageClasses'
	],
	#category : #'NewTools-SystemReporter'
}

{ #category : #initialization }
SpSizeReporter >> initialize [ 
	super initialize.
	imageClasses := self class environment allClasses.
]

{ #category : #'building report' }
SpSizeReporter >> reportLOC: aStream [
	self header: 'Number of LinesOfCode' on: aStream.
	aStream nextPutAll: '#All classes: '.
	aStream nextPutAll: (imageClasses inject: 0 into: [ :sum :each | sum + each linesOfCode]) asString


]

{ #category : #'building report' }
SpSizeReporter >> reportNbClasses: aStream [
	| effectiveClasses manifest tests baselineOf |

	effectiveClasses := imageClasses size. 
	manifest := (imageClasses count: #isManifest).
	tests := (imageClasses count: #isTestCase).
	baselineOf := (imageClasses count: [:c | c name beginsWith: 'BaselineOf' ]).
	effectiveClasses := effectiveClasses - manifest - tests.
	self header: 'Number of classes' on: aStream.
	aStream 
		nextPutAll: imageClasses size asString; cr ;
		nextPutAll: 'Tests: ' ;
		nextPutAll: tests asString ; cr ;
		"very long to compute :-(
		nextPutAll: 'Without instances: ' ;
		nextPutAll: (imageClasses count: [:c | c allInstances isEmpty]) asString ; cr ;"
		nextPutAll: 'Manifests: ' ;
		nextPutAll: manifest asString; cr ;
		nextPutAll: 'BaselineOf-s: ' ;
		nextPutAll:  baselineOf asString ; cr;
		nextPutAll: 'Effective classes: ';
		nextPutAll: effectiveClasses asString; cr.
		
		
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
