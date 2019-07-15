Class {
	#name : #SpecPreDebugPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'debugger',
		'textPresenter',
		'toolbar'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
SpecPreDebugPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #textPresenter;
		yourself
]

{ #category : #actions }
SpecPreDebugPresenter >> actions [
	^ (DebugSession
		debuggingActionsForPragmas: {#preDebuggingAction}
		for: self debugger)
		do: [ :preDebugAction | preDebugAction preDebugWindow: self ]
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
SpecPreDebugPresenter >> initializeWidgets [
	toolbar := self newDynamicToolbar.
	toolbar update.
	textPresenter := self newText.

	textPresenter disable.

	self focusOrder
		add: toolbar;
		add: textPresenter
]

{ #category : #initialization }
SpecPreDebugPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		whenClosedDo: [ debugger ifNotNil: #windowIsClosing ];
		initialExtent: 700 @ 180
]

{ #category : #accessing }
SpecPreDebugPresenter >> message: aString [
	textPresenter text: aString
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
