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
		add: #toolbar expand: false fill: false padding: 0;
		add: #textPresenter;
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

{ #category : #actions }
SpecPreDebugPresenter >> toolbarActions [
	| group |
	group := (CmCommandGroup named: 'Toolbar')
		decorateWith: SpCommandGroup.
	(DebugCommand preDebugCommandsForDebugger: self debugger)
		do: [ :cmd | 
			cmd decoratedCommand context: self.
			group register: cmd ].
	^ group
]
