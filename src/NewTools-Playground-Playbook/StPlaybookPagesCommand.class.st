"
Load page command for playbook
"
Class {
	#name : #StPlaybookPagesCommand,
	#superclass : #StPlaygroundPagesCommand,
	#category : #'NewTools-Playground-Playbook-Command'
}

{ #category : #actions }
StPlaybookPagesCommand >> loadPage: page [

	context activatePage: page
]
