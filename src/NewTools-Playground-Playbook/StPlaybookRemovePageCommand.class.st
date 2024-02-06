"
A command to temove page from current playbook
"
Class {
	#name : #StPlaybookRemovePageCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Playground-Playbook-Command'
}

{ #category : #default }
StPlaybookRemovePageCommand class >> defaultDescription [

	^ 'Remove selected playground from book.'
]

{ #category : #default }
StPlaybookRemovePageCommand class >> defaultName [

	^ 'Remove'
]

{ #category : #accessing }
StPlaybookRemovePageCommand class >> defaultShortcut [

	^ $x command mac | $x ctrl unix | $x ctrl win
]

{ #category : #executing }
StPlaybookRemovePageCommand >> execute [
	
	context doRemoveSelectedPage
]
