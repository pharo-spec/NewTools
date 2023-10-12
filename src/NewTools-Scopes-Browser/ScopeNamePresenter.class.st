"
I display a textfield to enter a the name of a new scope
"
Class {
	#name : 'ScopeNamePresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'textInput',
		'newScope'
	],
	#category : 'NewTools-Scopes-Browser-GUI',
	#package : 'NewTools-Scopes-Browser',
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
ScopeNamePresenter >> announceNewScope [

	self announcer announce: (NewScopeAnnouncement new)
]

{ #category : 'announcements' }
ScopeNamePresenter >> announceNewScope: aScope [

	self announcer announce: (NewScopeAnnouncement onScope: aScope)
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
		placeholder: 'Enter the name of the new scope';
		autoAccept: false;
		whenSubmitDo: [ :text | self submit ]
]

{ #category : 'initialization' }
ScopeNamePresenter >> newScope: aScope [
	newScope := aScope
]

{ #category : 'private' }
ScopeNamePresenter >> scopesManagerClass [
	^ ScopesManager
]

{ #category : 'private' }
ScopeNamePresenter >> submit [

	| text |
	[
	text := textInput text.
	self validate: text.
	newScope label: text.
	self announceNewScope: newScope.
	self close ]
		on: Error
		do: [ :e |
			self inform: e asString.
			textInput selectAll ]
]

{ #category : 'initialization' }
ScopeNamePresenter >> validate: text [

	text isEmpty ifTrue: [
		self error: 'Scope name cannot be empty' ].
	(self scopesManagerClass invalidNames includes: text)
		ifTrue: [
		self error: 'Invalid name: existing scope is named the same' ]
]
