Class {
	#name : 'ScopeNamePresenter',
	#superclass : 'ScopeAbstractPresenter',
	#instVars : [
		'textInput'
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
		whenSubmitDo: [ :text | 
			self validate.
			model newScope label: text.
			self announceNewScope.
			self close ]
]

{ #category : 'initialization' }
ScopeNamePresenter >> validate [

	self assert: textInput text isNotEmpty
]

{ #category : 'enumerating' }
ScopeNamePresenter >> whenSubmitDo: aBlock [

	textInput whenSubmitDo: aBlock
]
