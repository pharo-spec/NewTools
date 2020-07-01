"
I am a dummy counterpart to the DebuggerSystem class, used to test it.
"
Class {
	#name : #DummyDebuggerSystem,
	#superclass : #DebuggerSystem,
	#instVars : [
		'newUIProcessSpawned',
		'customUIManager'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'default values' }
DummyDebuggerSystem >> customUIManager: aUIManager [
	customUIManager := aUIManager
]

{ #category : #'default values' }
DummyDebuggerSystem >> debuggerSelectionStrategy [
	^ DummyDebuggerSelectionStrategy new
]

{ #category : #'default values' }
DummyDebuggerSystem >> defaultUIManager [
	customUIManager ifNil: [ ^ super defaultUIManager ].
	^ customUIManager
]

{ #category : #accessing }
DummyDebuggerSystem >> newUIProcessSpawned [
	newUIProcessSpawned ifNil: [ newUIProcessSpawned := false ].
	^ newUIProcessSpawned
]

{ #category : #helpers }
DummyDebuggerSystem >> spawnNewUIProcess [ 
	"For testing purposes. Does not actually spawn a new UI process. Just record that this method was called"
	newUIProcessSpawned := true
]

{ #category : #helpers }
DummyDebuggerSystem >> suspendDebuggedProcess: aDebugRequest [
	"Do not actually suspend the debugged process, in order to prevent the UI process from being suspended (image freeze) if a test goes wrong"
	^ 1
]
