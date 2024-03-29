Class {
	#name : 'StHaltOnReadCommand',
	#superclass : 'StBreakpointCommand',
	#category : 'NewTools-ObjectCentricBreakpoints',
	#package : 'NewTools-ObjectCentricBreakpoints'
}

{ #category : 'default' }
StHaltOnReadCommand class >> defaultDescription [

	^ 'Halts when the selected or any variable is read'
]

{ #category : 'deafult' }
StHaltOnReadCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StHaltOnReadCommand class >> defaultName [ 

	^ 'Halt on read'
]

{ #category : 'executing' }
StHaltOnReadCommand >> execute [
	^context haltInspectedObjectOnReadAccess
]
