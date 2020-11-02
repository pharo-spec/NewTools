"
I'm an abstract class. 
Better use my subclasses: 

```
StSystemReporter new openWithSpec
```

or 

```
StSizeReporter new openWithSpec
```


"
Class {
	#name : #StReporter,
	#superclass : #StPresenter,
	#instVars : [
		'reporter',
		'topicList',
		'reportText',
		'topics'
	],
	#classInstVars : [
		'reportText'
	],
	#category : #'NewTools-SystemReporter'
}

{ #category : #specs }
StReporter class >> defaultSpec [
	"self new openWithSpec"
	^ (SpBoxLayout newHorizontal 
			add: #topicList withConstraints: [ :constraints | constraints width: 140 ];
			add: #reportText;
			yourself)
]

{ #category : #specs }
StReporter class >> open [ 
	<script>
	self new openWithSpec
]

{ #category : #adding }
StReporter >> addTopicSpec: aPair [

	topics add: aPair
]

{ #category : #initialization }
StReporter >> connectPresenters [  
	
	topicList whenSelectionChangedDo: [ :selection | 
			selection selectedItems
				ifNotNil: [ :items |
								reportText text: (self createTextForReport: items)]].
						
	topicList items: topics
]

{ #category : #'building report' }
StReporter >> createTextForReport: items [

	^ (Text streamContents: [:stream | 
						items do: [:each |
								reporter perform: each value with: stream.
								stream cr]])
]

{ #category : #initialization }
StReporter >> fillTopics [

	^ self
]

{ #category : #utils }
StReporter >> header: aString on: aStream [
	aStream
		withAttribute: TextEmphasis bold
		do: [ aStream
				nextPutAll: aString;
				cr.
			aString size timesRepeat: [ aStream nextPut: $- ].
			aStream cr ]
]

{ #category : #initialization }
StReporter >> initialize [
	topics := OrderedCollection new.
	reporter := SystemReporter new.
	self fillTopics.
	super initialize.
	
]

{ #category : #initialization }
StReporter >> initializePresenters [ 

	topicList := self newList.
	topicList beMultipleSelection.
	topicList display: [ :each | each key ].
	reportText := self newText.
]

{ #category : #initialization }
StReporter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: self title.
	aWindowPresenter initialExtent: self extent
]

{ #category : #initialization }
StReporter >> topicSpec [

	^ topics
]
