"
A command to ""evaluate and go"" the content of a selection (evaluate the selection and open an inspector with the results).

"
Class {
	#name : 'StEvaluateCommand',
	#superclass : 'SpToolCommand',
	#category : 'NewTools-Inspector-Command',
	#package : 'NewTools-Inspector',
	#tag : 'Command'
}

{ #category : 'default' }
StEvaluateCommand class >> defaultDescription [

	^ 'Evaluate selection and open an inspection column.'
]

{ #category : 'default' }
StEvaluateCommand class >> defaultIconName [

	^ #go
]

{ #category : 'default' }
StEvaluateCommand class >> defaultName [

	^ 'Do it and go'
]

{ #category : 'default' }
StEvaluateCommand class >> defaultShortcutKey [

	^ $g actionModifier
]

{ #category : 'documentation' }
StEvaluateCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(doEvaluateAndGo)
]

{ #category : 'executing' }
StEvaluateCommand >> execute [
	
	self context doEvaluateAndGo
]
