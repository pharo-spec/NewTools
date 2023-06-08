"
Show the page bindings browser.
"
Class {
	#name : #StPlaygroundBindingsCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #default }
StPlaygroundBindingsCommand class >> defaultDescription [

	^ 'Edit bindings list.'
]

{ #category : #default }
StPlaygroundBindingsCommand class >> defaultIconName [

	^ #glamorousTable
]

{ #category : #default }
StPlaygroundBindingsCommand class >> defaultName [

	^ 'Bindings'
]

{ #category : #accessing }
StPlaygroundBindingsCommand class >> order [

	^ 10
]

{ #category : #execution }
StPlaygroundBindingsCommand >> execute [ 

	(StPlaygroundBindingsPresenter 
		newApplication: context application 
		model: context) 
		openDialog
]
