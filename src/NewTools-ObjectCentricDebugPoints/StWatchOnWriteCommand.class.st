"
I am the base class for commands to install from the inspector object-centric breakpoints on a variable's writings
"
Class {
	#name : 'StWatchOnWriteCommand',
	#superclass : 'StDebugPointSlotTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StWatchOnWriteCommand class >> defaultDescription [

	^ 'Saves values written for the selected or any variable'
]

{ #category : 'default' }
StWatchOnWriteCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StWatchOnWriteCommand class >> defaultName [ 

	^ 'Watch write'
]

{ #category : 'executing' }
StWatchOnWriteCommand >> execute [

	^ context watchInspectedObjectWrite
]
