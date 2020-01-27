Class {
	#name : #OCHaltOnReadCommand,
	#superclass : #OCBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
OCHaltOnReadCommand class >> defaultDescription [

	^ 'Halts when the selected or any variable is read'
]

{ #category : #deafult }
OCHaltOnReadCommand class >> defaultIconName [
	^#image	
]

{ #category : #default }
OCHaltOnReadCommand class >> defaultName [ 

	^ 'Halt on read'
]

{ #category : #executing }
OCHaltOnReadCommand >> execute [
	^context haltInspectedObjectOnReadAccess
]
