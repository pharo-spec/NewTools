"
A command to add a new page to current book.
"
Class {
	#name : #StPlaybookNewPageCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Playground-Playbook-Command'
}

{ #category : #default }
StPlaybookNewPageCommand class >> defaultDescription [

	^ 'Add new playground page.'
]

{ #category : #accessing }
StPlaybookNewPageCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : #default }
StPlaybookNewPageCommand class >> defaultName [

	^ 'New Page'
]

{ #category : #default }
StPlaybookNewPageCommand class >> order [

	^ 0
]

{ #category : #executing }
StPlaybookNewPageCommand >> execute [ 

	context doAddNewPage
]
