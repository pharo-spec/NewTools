"
I am the base class for commands to install from the inspector object-centric breakpoints on a method call, for a specific object. These object-centric breakpoints will only break once
"
Class {
	#name : 'StBreakOnCallOnceCommand',
	#superclass : 'StDebugPointNodeTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnCallOnceCommand class >> defaultDescription [

	^ 'Breaks once when this method is called'
]

{ #category : 'default' }
StBreakOnCallOnceCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StBreakOnCallOnceCommand class >> defaultName [ 

	^ 'Break once on call'
]

{ #category : 'executing' }
StBreakOnCallOnceCommand >> execute [

	^ context breakOnceOnCallToSelectedMethod
]
