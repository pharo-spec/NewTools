"
I just provide helper methods to generate and remove classes that use the `TStDebuggerExtension` trait.
These classes are used exclusively in tests, and should be part of the system (remove them in your `tearDown`).
"
Class {
	#name : #StDebuggerExtensionGeneratorForTests,
	#superclass : #Object,
	#category : #'NewTools-Debugger-Tests-Utils'
}

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> generateTestClass [

	self classInstaller make: [ :builder |
		  builder
			  name: #TStDebuggerExtensionTestClass;
			  traitComposition: TStDebuggerExtension;
			  superclass: SpPresenter;
			  category: 'NewTools-Debugger-Tests-Model'. ].

	self testClass class compile: 'defaultLayout ^ SpBoxLayout newVertical'.
	self testClass class compile: 'isOnlyForTests ^ true'.
	self testClass compile: 'debuggerExtensionToolName ^ ''TStDebuggerExtensionTestClass'''.
]

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> removeTestClass [

	Smalltalk
		at: #TStDebuggerExtensionTestClass
		ifPresent: [ :class | class removeFromSystem ]
]

{ #category : #running }
StDebuggerExtensionGeneratorForTests class >> testClass [

	^ Smalltalk at: #TStDebuggerExtensionTestClass
]
