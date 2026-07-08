"
Remove a page (and its versions) from the page cache.

"
Class {
	#name : 'StPlaygroundRemovePageCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundRemovePageCommand class >> defaultDescription [

	^ 'Remove page and all its versions'
]

{ #category : 'default' }
StPlaygroundRemovePageCommand class >> defaultName [

	^ 'Remove page'
]

{ #category : 'executing' }
StPlaygroundRemovePageCommand >> execute [

	self context doRemovePage
]
