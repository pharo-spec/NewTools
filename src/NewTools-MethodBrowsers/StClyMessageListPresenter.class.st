Class {
	#name : 'StClyMessageListPresenter',
	#superclass : 'StMessageListPresenter',
	#instVars : [
		'scopes',
		'query'
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
StClyMessageListPresenter >> query [

	^ query
]

{ #category : 'accessing' }
StClyMessageListPresenter >> query: aQuery [

	query := aQuery
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes [

	^ scopes
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes: aCollectionOfScopes [

	scopes := aCollectionOfScopes
]

{ #category : 'updating' }
StClyMessageListPresenter >> switchScopeTo: aScope [

	query ifNil: [ ^ self ].
	query := query withScope: aScope.
	self updateMessages
]

{ #category : 'updating' }
StClyMessageListPresenter >> updateMessages [

	self messages: (self query execute items collect: [ :each | each actualObject ])
]
