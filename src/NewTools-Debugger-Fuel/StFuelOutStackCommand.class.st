"
Serializes a portion of the current stack trace using fuel.
"
Class {
	#name : #StFuelOutStackCommand,
	#superclass : #StDebuggerCommand,
	#category : #'NewTools-Debugger-Fuel'
}

{ #category : #accessing }
StFuelOutStackCommand class >> defaultDescription [
	^ 'Serialize a portion of the current stack trace using fuel.'
]

{ #category : #initialization }
StFuelOutStackCommand class >> defaultIconName [
	^ #smallExport
]

{ #category : #accessing }
StFuelOutStackCommand class >> defaultName [	
	^ 'Fuel out stack'
]

{ #category : #initialization }
StFuelOutStackCommand class >> defaultShortcut [
	^ nil
]

{ #category : #testing }
StFuelOutStackCommand >> appliesTo: aDebugger [
	^ true
]

{ #category : #executing }
StFuelOutStackCommand >> execute [

	| fileName |
	UIManager inform: 'Starting fueling out stack'.
	fileName := FLDebuggerStackSerializer serializeStackFromContext:
		            self context interruptedContext.
	UIManager inform:
		'Stack has been fueled out in file named: ' , fileName
]
