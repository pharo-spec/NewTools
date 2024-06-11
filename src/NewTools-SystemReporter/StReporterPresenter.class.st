"
I'm an abstract class. 
Better use my subclasses: 

```
StSystemReporter new open
```

or 

```
StSizeReporter new open
```


"
Class {
	#name : 'StReporterPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'topicList',
		'reportText',
		'topics'
	],
	#category : 'NewTools-SystemReporter-Base',
	#package : 'NewTools-SystemReporter',
	#tag : 'Base'
}

{ #category : 'layout' }
StReporterPresenter class >> defaultLayout [
	"self open"
	^ (SpBoxLayout newLeftToRight 
			add: #topicList withConstraints: [ :constraints | constraints width: 140 ];
			add: #reportText;
			yourself)
]

{ #category : 'specs' }
StReporterPresenter class >> open [

	<script>
	self new open
]

{ #category : 'adding' }
StReporterPresenter >> addTopicSpec: aPair [

	topics add: aPair
]

{ #category : 'initialization' }
StReporterPresenter >> connectPresenters [  
	
	topicList whenSelectionChangedDo: [ :selection | 
			selection selectedItems
				ifNotNil: [ :items |
								reportText text: (self createTextForReport: items)]].
						
	topicList items: topics
]

{ #category : 'building report' }
StReporterPresenter >> createTextForReport: items [

	^ (Text streamContents: [:stream | 
						items do: [:each |
								self perform: each value with: stream.
								stream cr]])
]

{ #category : 'utils' }
StReporterPresenter >> enumerate: aBlock on: aStream [

	self 
		enumerate: aBlock 
		startAt: 0 
		on: aStream
]

{ #category : 'utils' }
StReporterPresenter >> enumerate: aBlock startAt: first on: aStream [
	"Utility method to enumerate Options or Parameters from first to 1000"

	| idx value |
	idx := first.
	[ 
	value := aBlock value: idx.
	value isNil or: [ idx > 1000 ] ]
		whileFalse: [ 
			aStream
				nextPut: $#;
				nextPutAll: idx printString;
				tab;
				nextPutAll: value;
				cr.
			idx := idx + 1 ].
	idx = first
		ifTrue: [ 
			aStream
				nextPutAll: 'none';
				cr ]
]

{ #category : 'initialization' }
StReporterPresenter >> fillTopics [

	^ self
]

{ #category : 'utils' }
StReporterPresenter >> header: aString on: aStream [
	aStream
		withAttribute: TextEmphasis bold
		do: [ aStream
				nextPutAll: aString;
				cr.
			aString size timesRepeat: [ aStream nextPut: $- ].
			aStream cr ]
]

{ #category : 'initialization' }
StReporterPresenter >> initialize [
	topics := OrderedCollection new.
	self fillTopics.
	super initialize.
	
]

{ #category : 'initialization' }
StReporterPresenter >> initializePresenters [ 

	topicList := self newList.
	topicList beMultipleSelection.
	topicList display: [ :each | each key ].
	reportText := self newText beNotEditable.
]

{ #category : 'initialization' }
StReporterPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: self title.
	aWindowPresenter initialExtent: self extent
]

{ #category : 'initialization' }
StReporterPresenter >> topicSpec [

	^ topics
]
