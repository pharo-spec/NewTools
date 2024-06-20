"
I am the base class for commands to install from the inspector object-centric breakpoints on a method call, for a specific object. These object-centric breakpoints will only break once
"
Class {
	#name : 'StBreakOnCallToSelectorOnceCommand',
	#superclass : 'StDebugPointNodeTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnCallToSelectorOnceCommand class >> defaultDescription [

	^ 'Breaks once when this method is called'
]

{ #category : 'default' }
StBreakOnCallToSelectorOnceCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StBreakOnCallToSelectorOnceCommand class >> defaultName [ 

	^ 'Break once on call'
]

{ #category : 'executing' }
StBreakOnCallToSelectorOnceCommand >> execute [

	^ context breakOnceOnCallToSelectedMethod
]
