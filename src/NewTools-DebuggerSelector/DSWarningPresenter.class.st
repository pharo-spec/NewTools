"
I am a simple presenter for warnings.
I hold the exception, the process and the notification string from which the warning was raised.
If you click ""proceed"": the exception is resumed and this window is closed.
Closing the window manually resumes the exception.
If you click debug, a debugger opens on the warning.
"
Class {
	#name : #DSWarningPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'exception',
		'process',
		'uiManager',
		'notificationString',
		'text',
		'action'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #specs }
DSWarningPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #text;
		yourself
]

{ #category : #accessing }
DSWarningPresenter >> action: aSymbol [
	action := aSymbol
]

{ #category : #actions }
DSWarningPresenter >> close [
	self withWindowDo: #close
]

{ #category : #actions }
DSWarningPresenter >> debug [
	NewDebuggerSelector
		debugException: exception
		inProcess: process
		from: uiManager
]

{ #category : #accessing }
DSWarningPresenter >> exception [
	^ exception
]

{ #category : #accessing }
DSWarningPresenter >> exception: anObject [
	exception := anObject
]

{ #category : #initialization }
DSWarningPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	(aDialogWindowPresenter
		addButton: 'Debug'
		do: [ :presenter | 
			self action: #debug.
			presenter close ]) icon: (self iconNamed: #smallDebug).
	(aDialogWindowPresenter
		addButton: 'Proceed'
		do: [ :presenter | 
			self action: #proceed.
			presenter close ]) icon: (self iconNamed: #smallDoIt)
]

{ #category : #initialization }
DSWarningPresenter >> initializePresenters [
	text := self newText.
	text text: notificationString.
	text disable.
	self withWindowDo: [ :w | w title: 'Warning' ]
]

{ #category : #initialization }
DSWarningPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter title: 'Warning'.
	aWindowPresenter
		whenClosedDo: [ action = #debug
				ifTrue: [ self debug ]
				ifFalse: [ self proceed ] ]
]

{ #category : #accessing }
DSWarningPresenter >> notificationString [
	^ notificationString
]

{ #category : #accessing }
DSWarningPresenter >> notificationString: anObject [
	notificationString := anObject
]

{ #category : #actions }
DSWarningPresenter >> proceed [
	NewDebuggerSelector resumeException: exception
]

{ #category : #accessing }
DSWarningPresenter >> process [
	^ process
]

{ #category : #accessing }
DSWarningPresenter >> process: anObject [
	process := anObject
]

{ #category : #accessing }
DSWarningPresenter >> session [
	^ self debugger session
]

{ #category : #accessing }
DSWarningPresenter >> uiManager [
	^ uiManager
]

{ #category : #accessing }
DSWarningPresenter >> uiManager: anObject [
	uiManager := anObject
]
