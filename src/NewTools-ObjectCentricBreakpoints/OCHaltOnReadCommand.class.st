Class {
	#name : #OCHaltOnReadCommand,
	#superclass : #OCBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
OCHaltOnReadCommand class >> defaultDescription [

	^ 'Halts when the selected or any variable is read'
]

{ #category : #default }
OCHaltOnReadCommand class >> defaultName [ 

	^ 'Halt on read'
]

{ #category : #executing }
OCHaltOnReadCommand >> execute [
	context inspect
]
