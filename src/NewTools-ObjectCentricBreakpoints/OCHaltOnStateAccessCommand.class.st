Class {
	#name : #OCHaltOnStateAccessCommand,
	#superclass : #OCBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
OCHaltOnStateAccessCommand class >> defaultDescription [

	^ 'Halts when the selected or any variable is read or written'
]

{ #category : #default }
OCHaltOnStateAccessCommand class >> defaultName [ 

	^ 'Halt on state access'
]

{ #category : #executing }
OCHaltOnStateAccessCommand >> execute [
	^context haltInspectedObjectOnStateAccess
]
