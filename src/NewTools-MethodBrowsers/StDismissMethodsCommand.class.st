"
Dismiss selected method from a message browser list
"
Class {
	#name : 'StDismissMethodsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StDismissMethodsCommand class >> defaultDescription [

	^ 'Dismiss selected method from current results'
]

{ #category : 'default' }
StDismissMethodsCommand class >> defaultName [

	^ 'Dismiss from results'
]

{ #category : 'testing' }
StDismissMethodsCommand >> canBeExecuted [

	^ context selectedMethods isNotEmpty
]

{ #category : 'executing' }
StDismissMethodsCommand >> execute [

	context methods removeAll: context selectedMethods.
	context update
]
