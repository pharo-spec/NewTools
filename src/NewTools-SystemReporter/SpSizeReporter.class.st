"
I'm a reporter dedicated to size of the system.

```
SpSizeReporter new openWithSpec
```
"
Class {
	#name : #SpSizeReporter,
	#superclass : #SpReporter,
	#category : #'NewTools-SystemReporter'
}

{ #category : #'building report' }
SpSizeReporter >> reportLOC: aStream [
	self header: 'Number of LinesOfCode' on: aStream.
	aStream 
		nextPutAll: 'a lot !' ; cr

]

{ #category : #'building report' }
SpSizeReporter >> reportNbClasses: aStream [
	| imageClasses |
	imageClasses := Smalltalk globals allClasses.
	self header: 'Number of classes' on: aStream.
	aStream 
		nextPutAll: imageClasses size asString; cr ;
		nextPutAll: 'Tests: ' ;
		nextPutAll: (imageClasses count: #isTestCase) asString ; cr ;
		"very long to compute :-(
		nextPutAll: 'Without instances: ' ;
		nextPutAll: (imageClasses count: [:c | c allInstances isEmpty]) asString ; cr ;"
		nextPutAll: 'Manifests: ' ;
		nextPutAll: (imageClasses count: #isManifest) asString; cr ;
		nextPutAll: 'BaselineOf-s: ' ;
		nextPutAll: (imageClasses count: [:c | c name beginsWith: 'BaselineOf' ]) asString ; cr
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
