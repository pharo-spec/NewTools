Class {
	#name : 'ScopeRequestLabel',
	#superclass : 'SpRequestTextDialog',
	#category : 'NewTools-Scopes-Browser-GUI',
	#package : 'NewTools-Scopes-Browser',
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
