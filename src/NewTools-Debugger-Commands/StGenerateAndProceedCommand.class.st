Class {
	#name : 'StGenerateAndProceedCommand',
	#superclass : 'StDebuggerCommand',
	#category : 'NewTools-Debugger-Commands',
	#package : 'NewTools-Debugger-Commands'
}

{ #category : 'default' }
StGenerateAndProceedCommand class >> defaultDescription [

	^ 'Save and compile the modified source, relinquish debugger control and proceed execution from the start of the current method.'
]

{ #category : 'default' }
StGenerateAndProceedCommand class >> defaultIconName [

	^ #debuggerProceed
]

{ #category : 'default' }
StGenerateAndProceedCommand class >> defaultName [

	<toolbarDebugCommand: 1200>
 	^ 'Gen.&Proceed'
]

{ #category : 'default' }
StGenerateAndProceedCommand class >> defaultShortcut [

	^ $g meta
]

{ #category : 'testing' }
StGenerateAndProceedCommand >> appliesTo: aDebugger [

	^ aDebugger canGenerateAndProceed
]

{ #category : 'testing' }
StGenerateAndProceedCommand >> execute [

	self debugger saveGeneratedCodeAndProceed
]
