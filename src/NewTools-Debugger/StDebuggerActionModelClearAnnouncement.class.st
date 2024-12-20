Class {
	#name : 'StDebuggerActionModelClearAnnouncement',
	#superclass : 'StDebuggerActionModelAnnouncement',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'initialize' }
StDebuggerActionModelClearAnnouncement >> on: aDebuggerActionModel [

	self debuggerActionModel: aDebuggerActionModel.
]
