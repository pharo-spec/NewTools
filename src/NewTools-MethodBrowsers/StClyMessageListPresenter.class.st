Class {
	#name : 'StClyMessageListPresenter',
	#superclass : 'StMessageListPresenter',
	#instVars : [
		'scopes'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'private - actions' }
StClyMessageListPresenter >> doRemoveMethod [

	(RBRemoveMethodDriver new
		scopes: self scopes
		methods: { self selectedMethod }) 
		runRefactoring	
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes [

	^ scopes
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes: aCollectionOfScopes [

	scopes := aCollectionOfScopes
]
