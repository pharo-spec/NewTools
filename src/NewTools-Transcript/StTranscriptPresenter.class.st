"
I a simple presenter that displays the contents of newThreadSafeTranscript instances.
I listen to the NewEntryToTranscript announcement to refresh my contents.


"
Class {
	#name : 'StTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'text',
		'transcript'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'accessing' }
StTranscriptPresenter class >> defaultPreferredExtent [

	^ 300@700
]

{ #category : 'accessing' }
StTranscriptPresenter class >> example [
	"this example shows that we can use a different instance than the singleton."
	<script>
	
	| t tr |
	t := self new. 
	tr := NewThreadSafeTranscript new.
	tr show: 'Hello Pharo I''m a new textual transcript'.
	t transcript: tr.
	t open. 
]

{ #category : 'accessing' }
StTranscriptPresenter class >> exampleDefault [
	"this example shows that we can use a different instance than the singleton."
	<script>
	
	self new open
]

{ #category : 'accessing' }
StTranscriptPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'New Transcript')
		action: [ (Smalltalk tools toolNamed: #transcript) new open ];
		order: 2;
		parent: #InputOutput;
		help: 'Transcript';
		keyText: 'o, t';
		help: 'Window on the new Transcript output stream, which is useful for writing log messages.';
		iconName: self taskbarIconName.
	aBuilder withSeparatorAfter
]

{ #category : 'tools registry' }
StTranscriptPresenter class >> registerToolsOn: aRegistry [
	"Smalltalk tools register: self as: #newTranscript"
	
	aRegistry register: self as: #transcript
]

{ #category : 'initialization' }
StTranscriptPresenter >> initialize [ 

	super initialize.
	self registerToAnnouncer. 
	transcript := NewThreadSafeTranscript uniqueInstance
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializePresenters [ 


	text := self newText.
	
	
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenOpenedDo: [ self updateNewEntry ];
		whenClosedDo: [ self unregister ]
]

{ #category : 'accessing' }
StTranscriptPresenter >> layout [ 

	^ SpBoxLayout newLeftToRight 
			add: text;
			yourself
]

{ #category : 'registration' }
StTranscriptPresenter >> registerToAnnouncer [

	
	SystemAnnouncer uniqueInstance
		when: NewEntryToTranscript
		send: #updateNewEntry
		to: self
]

{ #category : 'accessing' }
StTranscriptPresenter >> text [

	^ text
]

{ #category : 'accessing' }
StTranscriptPresenter >> transcript: aTranscript [

	transcript := aTranscript.
	self updateNewEntry
]

{ #category : 'registration' }
StTranscriptPresenter >> unregister [

	^ SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : 'accessing' }
StTranscriptPresenter >> updateNewEntry [

	text text: transcript contents.
	
]

{ #category : 'accessing' }
StTranscriptPresenter >> windowTitle [

	^ 'New basic transcript'
]
