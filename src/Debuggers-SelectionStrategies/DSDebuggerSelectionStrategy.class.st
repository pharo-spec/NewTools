Class {
	#name : #DSDebuggerSelectionStrategy,
	#superclass : #Object,
	#instVars : [
		'debuggers',
		'handled',
		'error'
	],
	#classInstVars : [
		'debuggerSelectionStrategy'
	],
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #settings }
DSDebuggerSelectionStrategy class >> debuggerSelectionStrategy [
	^debuggerSelectionStrategy ifNil:[debuggerSelectionStrategy := DSDebuggerSelector]
]

{ #category : #settings }
DSDebuggerSelectionStrategy class >> debuggerSelectionStrategy: aClass [
	debuggerSelectionStrategy := aClass
]

{ #category : #settings }
DSDebuggerSelectionStrategy class >> debuggerSelectionStrategySettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #debuggerSelectionStrategy)
		label: 'Debugger selection strategy';
		target: DSDebuggerSelectionStrategy;
		default: DSSingleDebuggerSelector;
		parent: #debugging;
		domainValues: (DSDebuggerSelectionStrategy allSubclasses);
		description: 'Sets the strategy to open a debugger.'
]

{ #category : #instance }
DSDebuggerSelectionStrategy class >> with: aCollection [
	^ self new
		debuggers: aCollection;
		yourself
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> debuggers [
	^ debuggers
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> debuggers: aCollection [ 
	debuggers := aCollection
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> error [
	^error
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> handled [
	^handled ifNil:[handled := false]
]

{ #category : #accessing }
DSDebuggerSelectionStrategy >> hasErrors [ 
	^error notNil
]

{ #category : #iterating }
DSDebuggerSelectionStrategy >> nextDebugger [
	^ self subclassResponsibility
]

{ #category : #debuggers }
DSDebuggerSelectionStrategy >> openDebuggerForSession: aDebugSession [
	self subclassResponsibility 
]
