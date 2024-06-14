"
I am a command to install from the inspector object-centric breakpoints on a method call, for a specific object. 
"
Class {
	#name : 'StBreakOnCallToSelectorCommand',
	#superclass : 'StDebugPointNodeTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnCallToSelectorCommand class >> defaultDescription [

	^ 'Halts when this method is called'
]

{ #category : 'default' }
StBreakOnCallToSelectorCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
StBreakOnCallToSelectorCommand class >> defaultName [ 

	^ 'Break on call to selector'
]

{ #category : 'executing' }
StBreakOnCallToSelectorCommand >> execute [

	^ context breakOnCallToSelectedMethod
]
