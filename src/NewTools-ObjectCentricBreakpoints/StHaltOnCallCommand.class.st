Class {
	#name : #StHaltOnCallCommand,
	#superclass : #StBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
StHaltOnCallCommand class >> defaultDescription [

	^ 'Halts when this method is called'
]

{ #category : #deafult }
StHaltOnCallCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : #default }
StHaltOnCallCommand class >> defaultName [ 

	^ 'Halt on call'
]

{ #category : #testing }
StHaltOnCallCommand >> canBeExecuted [

	^ self appliesTo: context
]

{ #category : #executing }
StHaltOnCallCommand >> execute [

	^ context haltInspectedObjectOnCallToSelectedMethod
]
