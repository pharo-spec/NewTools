"
I'm an abstract class. 
Better use my subclasses: 

```
SpSystemReporter new openWithSpec
```

or 

```
SpSizeReporter new openWithSpec
```


"
Class {
	#name : #SpReporter,
	#superclass : #SpPresenter,
	#instVars : [
		'topicList',
		'reportText'
	],
	#classInstVars : [
		'reportText'
	],
	#category : #'NewTools-SystemReporter'
}

{ #category : #specs }
SpReporter class >> defaultSpec [
	"self new openWithSpec"
	^ (SpBoxLayout newHorizontal 
			add: #topicList withConstraints: [ :constraints | constraints width: 140 ];
			add: #reportText;
			yourself)
]

{ #category : #specs }
SpReporter class >> open [ 
	<script>
	self new openWithSpec
]

{ #category : #initialization }
SpReporter >> connectPresenters [  

	topicList whenSelectionChangedDo: [ :selection | 
			selection selectedItems
				ifNotNil: [ :items |
								reportText text: (self createTextForReport: items)]]
]

{ #category : #'building report' }
SpReporter >> createTextForReport: items [

	^ (Text streamContents: [:stream | 
						items do: [:each |
								self perform: each value with: stream.
								stream cr]])
]

{ #category : #utils }
SpReporter >> enumerate: aBlock on: aStream [
	self enumerate: aBlock startAt: 0 on: aStream
]

{ #category : #utils }
SpReporter >> enumerate: aBlock startAt: first on: aStream [
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

{ #category : #utils }
SpReporter >> header: aString on: aStream [
	aStream
		withAttribute: TextEmphasis bold
		do: [ aStream
				nextPutAll: aString;
				cr.
			aString size timesRepeat: [ aStream nextPut: $- ].
			aStream cr ]
]

{ #category : #initialization }
SpReporter >> initializePresenters [ 

	topicList := self newList.
	topicList beMultipleSelection.
	topicList display: [ :each | each key ].
	topicList items: self topicSpec.
	reportText := self newText.
]

{ #category : #initialization }
SpReporter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: self title
]

{ #category : #initialization }
SpReporter >> topicSpec [

	^ #()
]
