Class {
	#name : #StPlaygroundCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #testing }
StPlaygroundCommand class >> isAbstract [

	^ self == StPlaygroundCommand
]
