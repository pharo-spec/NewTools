Class {
	#name : 'StDebuggerActionModelAnnouncementTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugActionModel'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
StDebuggerActionModelAnnouncementTest >> setUp [

	super setUp.
	debugActionModel := StMockDebuggerActionModel new
]

{ #category : 'tests' }
StDebuggerActionModelAnnouncementTest >> testDebuggerActionModel [

	| actionModelAnnouncement |
	actionModelAnnouncement := StDebuggerActionModelAnnouncement
		                           debuggerActionModel: debugActionModel.

	self
		assert: actionModelAnnouncement debuggerActionModel
		identicalTo: debugActionModel
]
