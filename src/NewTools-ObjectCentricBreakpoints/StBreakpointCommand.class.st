Class {
	#name : 'StBreakpointCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-ObjectCentricBreakpoints',
	#package : 'NewTools-ObjectCentricBreakpoints'
}

{ #category : 'testing' }
StBreakpointCommand >> appliesTo: aTool [
	^ [ aTool owner class ~= StDebuggerRawObjectInspector ]
		on: Error
		do: [ false ]
]

{ #category : 'converting' }
StBreakpointCommand >> asSpecCommand [
	| command |

	command := super asSpecCommand.
	self class defaultIconName ifNotNil: [ :iconName |
		command iconName: iconName ].
	
	^ command
]

{ #category : 'testing' }
StBreakpointCommand >> canBeExecuted [

	^ context enableSlotMenuEntries
]
