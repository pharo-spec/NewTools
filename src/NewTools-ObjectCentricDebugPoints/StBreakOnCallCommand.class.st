"
I am a command to install from the inspector object-centric breakpoints on a method call, for a specific object. 
"
Class {
	#name : 'StBreakOnCallCommand',
	#superclass : 'StDebugPointNodeTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnCallCommand class >> defaultDescription [

	^ 'Halts when this method is called'
]

{ #category : 'default' }
StBreakOnCallCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StBreakOnCallCommand class >> defaultName [ 

	^ 'Break on call'
]

{ #category : 'executing' }
StBreakOnCallCommand >> execute [

	^ context breakOnCallToSelectedMethod
]
