"
Instead of executing a normal step, this command skips the next bytecode to be executed.
It has the same granularity than the step-in command.
Executing a skip sets the next bytecode in line to be executed, therefore you must be careful when skipping instructions as you could skip a bytecode that sets a required value to execute the rest of your method.

A good example of using skip would be the following:
You start debugging a method in which you write in to a stream.
You notice a problem so you fix your method and recompiles it, which triggers a context restart.
In that case, the execution counter is set back to the beggining of that method but the state is not set back.
Therefore, if you execute again you will write the same values in your stream.
You can use skip to avoid all writings in your stream until you get back to the correct point of the execution where you can start writing again in the stream.
"
Class {
	#name : #SindarinSkipCommand,
	#superclass : #SindarinSkipAllToSelectionCommand,
	#category : #'NewTools-Sindarin-Commands'
}

{ #category : #'accessing - defaults' }
SindarinSkipCommand class >> defaultDescription [
	^ 'Skips execution of the next step, then returns debugger control.'
]

{ #category : #'accessing - defaults' }
SindarinSkipCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 1>
	<codeExtensionDebugCommand: 1>
	^ 'Skip'
]

{ #category : #hooks }
SindarinSkipCommand >> execute [

	self flag:
		'Context should actually be a debugger or a sindarin debugger'.
	self context sindarinDebugger skip.
	self context forceSessionUpdate
]
