Class {
	#name : 'ScopeNamePresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'textInput'
	],
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopeNamePresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: 'Nombre';
				   add: #textInput
				   expand: true
				   fill: true
				   padding: 0;
				   yourself)
		  expand: false
]

{ #category : 'layout' }
ScopeNamePresenter class >> title [
	^ 'Scope name?'
]

{ #category : 'announcements' }
ScopeNamePresenter >> announceScopeNameEntered [

	self announcer announce: (ScopeNameEnteredAnnouncement on: self scopeName)
]

{ #category : 'initialize-release' }
ScopeNamePresenter >> close [
	self window close
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

	self assert: textInput text isNotEmpty
]
