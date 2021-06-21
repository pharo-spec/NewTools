"
Loads a debugging script that has been saved in a Sindarin script class.
"
Class {
	#name : #SindarinLoadScriptCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinLoadScriptCommand class >> defaultDescription [
	^'Load a debugging script'
]

{ #category : #'accessing - defaults' }
SindarinLoadScriptCommand class >> defaultIconName [
	^#smallLoadProject
]

{ #category : #'accessing - defaults' }
SindarinLoadScriptCommand class >> defaultName [
	^'Load script'
]

{ #category : #executing }
SindarinLoadScriptCommand >> execute [
	self context loadScript
]
