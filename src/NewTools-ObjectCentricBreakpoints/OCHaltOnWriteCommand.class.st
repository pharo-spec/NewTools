Class {
	#name : #OCHaltOnWriteCommand,
	#superclass : #OCBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
OCHaltOnWriteCommand class >> defaultDescription [

	^ 'Halts when the selected or any variable is written'
]

{ #category : #deafult }
OCHaltOnWriteCommand class >> defaultIconName [
	^#smallLoadProject	
]

{ #category : #default }
OCHaltOnWriteCommand class >> defaultName [ 

	^ 'Halt on write'
]

{ #category : #executing }
OCHaltOnWriteCommand >> execute [
	^context haltInspectedObjectOnWriteAccess
]
