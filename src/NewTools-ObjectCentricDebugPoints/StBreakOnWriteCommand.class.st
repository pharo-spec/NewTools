"
I am the base class for commands to install from the inspector object-centric breakpoints on a variable's writings
"
Class {
	#name : 'StBreakOnWriteCommand',
	#superclass : 'StDebugPointSlotTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnWriteCommand class >> defaultDescription [

	^ 'Breaks when the selected or any variable is written'
]

{ #category : 'default' }
StBreakOnWriteCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StBreakOnWriteCommand class >> defaultName [ 

	^ 'Break on write'
]

{ #category : 'executing' }
StBreakOnWriteCommand >> execute [

	^ context breakInspectedObjectOnWrite
]
