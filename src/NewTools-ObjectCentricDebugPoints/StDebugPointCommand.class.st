"
I am the base class for commands to install from the inspector object-centric debug points 
"
Class {
	#name : 'StDebugPointCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'testing' }
StDebugPointCommand >> appliesTo: aTool [
	^ [ aTool owner class ~= StDebuggerRawObjectInspector ]
		on: Error
		do: [ false ]
]

{ #category : 'converting' }
StDebugPointCommand >> asSpecCommand [

	| command |
	command := super asSpecCommand.
	self class defaultIconName ifNotNil: [ :iconName |
		command iconName: iconName ].

	^ command
]
