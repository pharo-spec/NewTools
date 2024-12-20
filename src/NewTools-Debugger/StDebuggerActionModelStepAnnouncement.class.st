Class {
	#name : 'StDebuggerActionModelStepAnnouncement',
	#superclass : 'StDebuggerActionModelAnnouncement',
	#instVars : [
		'step'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'debugging actions' }
StDebuggerActionModelStepAnnouncement class >> stepInto: aDebuggerActionModel [

	^ (self debuggerActionModel: aDebuggerActionModel)
		  stepInto;
		  yourself
]

{ #category : 'debugging actions' }
StDebuggerActionModelStepAnnouncement class >> stepOver: aDebuggerActionModel [

	^ (self debuggerActionModel: aDebuggerActionModel)
		  stepOver;
		  yourself
]

{ #category : 'debugging actions' }
StDebuggerActionModelStepAnnouncement class >> stepThrough: aDebuggerActionModel [

	^ (self debuggerActionModel: aDebuggerActionModel)
		  stepThrough;
		  yourself
]

{ #category : 'actions' }
StDebuggerActionModelStepAnnouncement >> stepInto [
	step := 'into'
]

{ #category : 'actions' }
StDebuggerActionModelStepAnnouncement >> stepOver [
	step := 'over'
]

{ #category : 'actions' }
StDebuggerActionModelStepAnnouncement >> stepThrough [
	step := 'through'
]
