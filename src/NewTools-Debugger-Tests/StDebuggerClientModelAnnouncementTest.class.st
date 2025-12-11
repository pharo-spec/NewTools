Class {
	#name : 'StDebuggerClientModelAnnouncementTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugActionModel'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
StDebuggerClientModelAnnouncementTest >> setUp [

	super setUp.
	debugActionModel := StMockDebuggerClientModel new
]

{ #category : 'tests' }
StDebuggerClientModelAnnouncementTest >> testDebuggerClientModel [

	| actionModelAnnouncement |
	actionModelAnnouncement := StDebuggeClientModelAnnouncement
		                           debuggerClientModel: debugActionModel.

	self
		assert: actionModelAnnouncement debuggerClientModel
		identicalTo: debugActionModel
]
