Class {
	#name : 'ScopeRequestLabel',
	#superclass : 'SpRequestTextDialog',
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'GUI'
}

{ #category : 'initialization' }
ScopeRequestLabel >> initializePresenters [
	super initializePresenters.
	textInput := self newTextInput.
	
	self initializeTextInput 
]

{ #category : 'initialization' }
ScopeRequestLabel >> initializeTextInput [

	textInput
		placeholder: 'Enter the name of the new scope';
		autoAccept: false;
		whenSubmitDo: [ :text | self accept ]
]
