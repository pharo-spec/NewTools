"
I'm a reporter dedicated to size of the system.

```
StSizeReporter new openWithSpec
```

"
Class {
	#name : #StSizeReporter,
	#superclass : #StReporter,
	#category : #'NewTools-SystemReporter'
}

{ #category : #'system menu' }
StSizeReporter class >> systemReporterMenuOn: aBuilder [ 
	<worldMenu>
	
	(aBuilder item: #'Size Reporter')
		parent: #System;
		action: [ self open ];
		help: 'Reports different numbers on the size of the image.'
]

{ #category : #'building report' }
StSizeReporter >> extent [

	^ 600@ 400
]

{ #category : #initialization }
StSizeReporter >> fillTopics [

  {	#'# smart report' -> #reportSmartInfo: .
	#'# raw classes' -> #reportNbClasses:  .
	#'# raw traits' -> #reportNbTraits: .
	#'# raw LOC' -> #reportLOC: }
		do: [ :each | self addTopicSpec: each ].

		 
]

{ #category : #initialization }
StSizeReporter >> initialize [ 
	super initialize.
	topicList selectIndex: 1.
]

{ #category : #ui }
StSizeReporter >> title [ 

	^ 'Size reporter'
]

{ #category : #'building report' }
StSizeReporter >> topicSpec [
  {	#'# smart report' -> #reportSmartInfo: .
	#'# raw classes' -> #reportNbClasses:  .
	#'# raw traits' -> #reportNbTraits: .
	#'# raw LOC' -> #reportLOC: }
		do: [ :each | self addTopicSpec: each ].
	^ topics
		 
]
