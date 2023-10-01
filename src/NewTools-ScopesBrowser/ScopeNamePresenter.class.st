Class {
	#name : 'ScopeNamePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textInput'
	],
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopeNamePresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: 'Nombre';
		  add: #textInput
		  expand: true
		  fill: true
		  padding: 0
]

{ #category : 'announcements' }
ScopeNamePresenter >> announceScopeNameEntered [

	announcer announce: (ScopeNameEnteredAnnouncement on: self scopeName)
]

{ #category : 'accessing' }
ScopeNamePresenter >> announcer: anAnnouncer [ 
	announcer := anAnnouncer
]

{ #category : 'initialization' }
ScopeNamePresenter >> initializePresenters [

	textInput := self newTextInput.
	self initializeTextInput
]

{ #category : 'initialization' }
ScopeNamePresenter >> initializeTextInput [
	textInput 
		placeholder: 'Enter the name of the scope';
		autoAccept: false;
		whenSubmitDo: [ :text | self returnName ]
]

{ #category : 'initialization' }
ScopeNamePresenter >> returnName [
	self validate.
	self announceScopeNameEntered.
	self close
]

{ #category : 'accessing' }
ScopeNamePresenter >> scopeName [
	^ textInput text
]

{ #category : 'initialization' }
ScopeNamePresenter >> validate [

	textInput text isEmpty ifTrue: [ self error: 'You must enter a name' ]
]
