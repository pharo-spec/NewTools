Class {
	#name : 'StDebuggerActionModelAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'debuggerActionModel',
		'node'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerActionModelAnnouncement class >> debuggerActionModel: aDebuggerActionModel [

	^ self new on: aDebuggerActionModel
]

{ #category : 'accessing' }
StDebuggerActionModelAnnouncement >> debuggerActionModel [

	^ debuggerActionModel
]

{ #category : 'accessing' }
StDebuggerActionModelAnnouncement >> debuggerActionModel: aDebuggerActionModel [

	debuggerActionModel := aDebuggerActionModel
]

{ #category : 'accessing' }
StDebuggerActionModelAnnouncement >> node [

	^ node
]

{ #category : 'initialize' }
StDebuggerActionModelAnnouncement >> on: aDebuggerActionModel [

	self debuggerActionModel: aDebuggerActionModel
]
