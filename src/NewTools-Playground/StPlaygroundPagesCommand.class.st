"
I open the page selector persenter and allow the user to chose a page to load.
"
Class {
	#name : 'StPlaygroundPagesCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundPagesCommand class >> defaultDescription [

	^ 'Load a saved page'
]

{ #category : 'accessing' }
StPlaygroundPagesCommand class >> defaultIconName [

	^ #more
]

{ #category : 'default' }
StPlaygroundPagesCommand class >> defaultName [

	^ 'Pages'
]

{ #category : 'accessing' }
StPlaygroundPagesCommand class >> order [

	^ 30
]

{ #category : 'execution' }
StPlaygroundPagesCommand >> execute [ 

	(StPlaygroundPagesPresenter 
		newApplication: context application
		model: context) 
		onLoadPage: [ :page |
			self loadPage: page.
			context takeKeyboardFocus ];
		openDialog
]

{ #category : 'actions' }
StPlaygroundPagesCommand >> loadPage: page [

	context loadPage: page
]
