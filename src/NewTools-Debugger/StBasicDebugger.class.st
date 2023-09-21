Class {
	#name : 'StBasicDebugger',
	#superclass : 'StPresenter',
	#traits : 'TDebugger',
	#classTraits : 'TDebugger classTrait',
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'instance creation' }
StBasicDebugger class >> debugSession: aDebugSession [
	'Going through basic debugger' crTrace.
	aDebugSession stack copy inspect
]
