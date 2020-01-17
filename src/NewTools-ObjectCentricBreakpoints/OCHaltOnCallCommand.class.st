Class {
	#name : #OCHaltOnCallCommand,
	#superclass : #OCBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
OCHaltOnCallCommand class >> defaultDescription [

	^ 'Halts when this method is called'
]

{ #category : #default }
OCHaltOnCallCommand class >> defaultName [ 

	^ 'Halt on call'
]

{ #category : #executing }
OCHaltOnCallCommand >> execute [
	^context haltInspectedObjectOnCallToSelectedMethod
]
