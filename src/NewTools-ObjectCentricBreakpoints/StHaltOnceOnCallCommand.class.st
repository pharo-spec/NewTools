Class {
	#name : 'StHaltOnceOnCallCommand',
	#superclass : 'StBreakpointCommand',
	#category : 'NewTools-ObjectCentricBreakpoints',
	#package : 'NewTools-ObjectCentricBreakpoints'
}

{ #category : 'default' }
StHaltOnceOnCallCommand class >> defaultDescription [

	^ 'Halts once when this method is called'
]

{ #category : 'deafult' }
StHaltOnceOnCallCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StHaltOnceOnCallCommand class >> defaultName [ 

	^ 'Halt once on call'
]

{ #category : 'testing' }
StHaltOnceOnCallCommand >> canBeExecuted [

	^ self appliesTo: context
]

{ #category : 'executing' }
StHaltOnceOnCallCommand >> execute [

	^ context haltOnceInspectedObjectOnCallToSelectedMethod
]
