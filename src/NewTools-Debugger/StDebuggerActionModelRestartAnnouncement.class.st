Class {
	#name : 'StDebuggerActionModelRestartAnnouncement',
	#superclass : 'StDebuggerActionModelAnnouncement',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'initialize' }
StDebuggerActionModelRestartAnnouncement >> on: aDebuggerActionModel [

	super on: aDebuggerActionModel.
	node := aDebuggerActionModel sourceNodeExecuted methodNode
]
