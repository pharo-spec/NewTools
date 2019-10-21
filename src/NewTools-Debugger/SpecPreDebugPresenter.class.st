Class {
	#name : #SpecPreDebugPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'debugger',
		'buttonBar',
		'text'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
SpecPreDebugPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #text;
		add: #buttonBar expand: false;
		yourself
]

{ #category : #actions }
SpecPreDebugPresenter >> close [
	self withWindowDo: #close
]

{ #category : #accessing }
SpecPreDebugPresenter >> debugger [
	^ debugger
]

{ #category : #initialization }
SpecPreDebugPresenter >> initializePresenters [

	text := self newText.
	text disable.
	
	buttonBar := self newButtonBar placeAtEnd.
	buttonBar items: (self toolbarActions allCommands 
		collect: [ :each | each asButtonPresenter ])
]

{ #category : #initialization }
SpecPreDebugPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		whenClosedDo: [ debugger ifNotNil: #windowIsClosing ];
		initialExtent: 700 @ 180
]

{ #category : #accessing }
SpecPreDebugPresenter >> message: aString [
	text text: aString
]

{ #category : #actions }
SpecPreDebugPresenter >> openFullDebugger [
	| currentDebugger |
	currentDebugger := self debugger.
	debugger := nil.
	self close.
	currentDebugger openWithFullView
]

{ #category : #accessing }
SpecPreDebugPresenter >> session [
	^ self debugger session
]

{ #category : #'accessing model' }
SpecPreDebugPresenter >> setModelBeforeInitialization: aDebugger [
	debugger := aDebugger
]

{ #category : #initialization }
SpecPreDebugPresenter >> setTitle: aString [
	self withWindowDo: [ :w | w title: aString ]
]

{ #category : #actions }
SpecPreDebugPresenter >> toolbarActions [
	| group |
	
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	(DebugCommand preDebugCommandsForDebugger: self debugger)
		do: [ :cmd | 
			cmd decoratedCommand context: self.
			group register: cmd ].
	
	^ group
]
