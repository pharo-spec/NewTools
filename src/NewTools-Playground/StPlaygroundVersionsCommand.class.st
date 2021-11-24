"
Open the page versions browsers.
"
Class {
	#name : #StPlaygroundVersionsCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #default }
StPlaygroundVersionsCommand class >> defaultDescription [

	^ 'Browse page versions'
]

{ #category : #accessing }
StPlaygroundVersionsCommand class >> defaultIconName [

	^ #history
]

{ #category : #default }
StPlaygroundVersionsCommand class >> defaultName [

	^ 'Versions'
]

{ #category : #accessing }
StPlaygroundVersionsCommand class >> order [

	^ 20
]

{ #category : #execution }
StPlaygroundVersionsCommand >> execute [ 

	(StPlaygroundPageVersionsPresenter 
		newApplication: context application
		model: context) 
		openDialogWithSpec
]
