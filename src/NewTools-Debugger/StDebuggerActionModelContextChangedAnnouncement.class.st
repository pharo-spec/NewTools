Class {
	#name : 'StDebuggerActionModelContextChangedAnnouncement',
	#superclass : 'StDebuggerActionModelAnnouncement',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'initialize' }
StDebuggerActionModelContextChangedAnnouncement >> on: aDebuggerActionModel [

	super on: aDebuggerActionModel.
	node := aDebuggerActionModel sourceNodeExecuted methodNode
]
