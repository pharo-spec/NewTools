"
I am the UI element for the TranscriptBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'TranscriptPresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#instVars : [
		'textInput'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'action handling' }
TranscriptPresenter >> activate [
	| bh |
	self behavior ifNotNil: [ ^self ].
	bh := (TranscriptBehavior new text: (self debugPoint properties at: #TranscriptText ifAbsent: '')).
	self debugPoint addBehavior: bh.
	self behavior: bh
]

{ #category : 'action handling' }
TranscriptPresenter >> deactivate [
	self debugPoint removeBehavior: TranscriptBehavior.
	self behavior: nil.
]

{ #category : 'accessing' }
TranscriptPresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	
	behavior := self debugPoint getBehavior: TranscriptBehavior.
	checkBox state: self behavior isNotNil.
	textInput enabled: checkBox state.
	(self behavior ifNotNil: [:bh | textInput text: bh text]).

]

{ #category : 'layout' }
TranscriptPresenter >> defaultLayout [ 
	| newLayout |
	
	newLayout := SpBoxLayout newTopToBottom
		add: checkBox expand: false;
		yourself.
		
	self behavior ifNotNil: [
		newLayout add: ( SpBoxLayout newLeftToRight borderWidth: 5;
			add: textInput expand: true ;
			yourself) height: 60;
		yourself].
		
	^newLayout

]

{ #category : 'initialization' }
TranscriptPresenter >> initializePresenters [ 
	
	textInput  := self newText.
	textInput whenTextChangedDo: [ self behavior ifNotNil: [behavior text: textInput text ]].
	checkBox := self newCheckBox label: 'Transcript: Logs to transcript at each hit'.
	checkBox whenActivatedDo: [ self activate ].
	checkBox whenDeactivatedDo: [ self deactivate ].
	
	
]
