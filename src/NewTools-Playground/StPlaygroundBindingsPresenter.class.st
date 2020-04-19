Class {
	#name : #StPlaygroundBindingsPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'bindingList',
		'playground',
		'inspector'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> defaultExtent [

	^ 650@400
]

{ #category : #specs }
StPlaygroundBindingsPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		add: #bindingList;
		add: #inspector;
		yourself
]

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> defaultTitle [

	^ 'Bindings'
]

{ #category : #accessing }
StPlaygroundBindingsPresenter >> bindings [

	^ playground bindings
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		centeredRelativeTo: playground window;
		addButton: 'Close' do: [ :presenter | 
			presenter triggerOkAction.
			presenter close ]
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializePresenters [

	bindingList := self newList
		display: [ :each | each key ];
		yourself.
	inspector := StInspector new.
	
	bindingList 
		transmitTo: inspector
		transform: [ :anAssociation | 
			anAssociation ifNotNil: [ anAssociation value ] ].
	 
	self updatePresenter
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self title;
		initialExtent: self class defaultExtent
]

{ #category : #'private factory' }
StPlaygroundBindingsPresenter >> newBindingPresenter: anAssociation [

	^ StPlaygroundBindingPresenter on: anAssociation
]

{ #category : #'private factory' }
StPlaygroundBindingsPresenter >> newBindingPresenterList [

	^ self bindings associations collect: [ :eachAssoc |
		self newBindingPresenter: eachAssoc ]
]

{ #category : #'accessing model' }
StPlaygroundBindingsPresenter >> setModelBeforeInitialization: anObject [

	playground := anObject
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> title [

	playground withWindowDo: [ :w | 
		^ 'Bindings for {1}' format: { w title } ].
	^ self class defaultTitle
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> updatePresenter [

	bindingList items: self bindings associations
]
