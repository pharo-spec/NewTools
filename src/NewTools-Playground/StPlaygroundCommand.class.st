"
A base command for playground actions (the ones that are specific of the playground).
"
Class {
	#name : #StPlaygroundCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #testing }
StPlaygroundCommand class >> isAbstract [

	^ self == StPlaygroundCommand
]
