Class {
	#name : #StHaltOnCallToSelectorCommand,
	#superclass : #StBreakpointCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #default }
StHaltOnCallToSelectorCommand class >> defaultDescription [

	^ 'Halts when this method is called'
]

{ #category : #deafult }
StHaltOnCallToSelectorCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : #default }
StHaltOnCallToSelectorCommand class >> defaultName [ 

	^ 'Halt on call'
]

{ #category : #testing }
StHaltOnCallToSelectorCommand >> canBeExecuted [

	^ self appliesTo: context
]

{ #category : #executing }
StHaltOnCallToSelectorCommand >> execute [

	^ context haltInspectedObjectOnCallToSelectedMethod
]
