"
This morphic debug session just redefines methods to be used in tests to avoid spawning new ui processes for real
"
Class {
	#name : 'StMorphicDebugSessionForTests',
	#superclass : 'StMorphicDebugSession',
	#instVars : [
		'newUIProcessSpawned'
	],
	#category : 'NewTools-Debugger-Morphic',
	#package : 'NewTools-Debugger-Morphic'
}

{ #category : 'process' }
StMorphicDebugSessionForTests >> newUIProcessSpawned [

	newUIProcessSpawned ifNil: [ newUIProcessSpawned := false ].
	^ newUIProcessSpawned
]

{ #category : 'process' }
StMorphicDebugSessionForTests >> spawnNewUIProcessIfNecessary [
	"we just want to avoid spawning UI processes, while ensuring that we actually called the ui process spawning logic "

	newUIProcessSpawned := errorWasInUIProcess
]
