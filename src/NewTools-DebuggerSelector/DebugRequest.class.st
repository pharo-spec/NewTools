"
The information required to open a debugger can take multiple forms.
This object is a builder, to be filled with the relevant information by any object that wants to open a debugger.
Once this object is filled, call its #debug or #warning method to open a debugger/send a warning.

# Information That Can Be Provided (and their type)
- exception: Exception
- context: Context
- label: String
- process: Process
- compiledMethod: CompiledMethod

# Notes
- You NEED to provide an exception OR a context. The other information are optional.
- If an exception and a label are provided, the label will be ignored (in favour of the #description of the exception)
- Providing a compiledMethod will make it so the execution will be stepped until it is in that method , prior to the debugger opening

# Instance Variables
- exception: Exception.
- context: Context.
- label: String. If not provided, the result of ""self defaultLabel_"" will be used.
- process: Process. If not provided, the result of ""self defaultProcess"" will be used.
- compiledMethod: CompiledMethod
- preDebugActions: OrderedCollection<BlockClosure<DebugSession, nil>>. A list of blocks, taking as arguments a DebugSession on the execution to be debugged. These will be executed before the debugger opens.

# Technical Details
- the setters are meant to be used by the caller, to fill this object with information
- the getters are meant to be used by whatever objects is opening a debugger based on the information contained in this object
"
Class {
	#name : #DebugRequest,
	#superclass : #Object,
	#instVars : [
		'exception',
		'context',
		'label',
		'uiManager',
		'process',
		'compiledMethod',
		'preDebugActions',
		'debugSession'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #'instance creation' }
DebugRequest class >> new [
	self shouldNotImplement
]

{ #category : #'instance creation' }
DebugRequest class >> newForContext: aContext [
	^ self basicNew context: aContext; yourself
]

{ #category : #'instance creation' }
DebugRequest class >> newForException: anException [
	^ self basicNew exception: anException; yourself
]

{ #category : #setter }
DebugRequest >> compiledMethod: anObject [
	compiledMethod := anObject
]

{ #category : #preDebugActions }
DebugRequest >> computePreDebugActions [
	"Fill the preDebugActions variable."
	"If compiledMethod is not nil, this DebugRequest has been created to debug the execution of a specific method. Add a pre-debug action to step the execution until that method is reached"
	compiledMethod ifNotNil: [ self preDebugActions add: (self preDebugActionForDebugItMethod: compiledMethod) ]
]

{ #category : #setter }
DebugRequest >> context: anObject [
	context := anObject
]

{ #category : #getter }
DebugRequest >> debugSession [
	"If a DebugSession is requested for this debug request, ask the process to create one. Subsequent calls to this method will return the same DebugSession (and not create another one)"
	debugSession ifNil: [ debugSession := (self process newDebugSessionNamed: self exception description startedAt: self exception signalerContext) exception: self exception; yourself ].
	^ debugSession.
]

{ #category : #'default values' }
DebugRequest >> defaultLabel [
	^ 'No label was provided'
]

{ #category : #'default values' }
DebugRequest >> defaultProcess [
	^ Processor activeProcess
]

{ #category : #'default values' }
DebugRequest >> defaultUIManager [
	^ UIManager default
]

{ #category : #getter }
DebugRequest >> exception [
	"If an exception was provided, return it, otherwise create a dummy exception using the provided context and label (if no label was provided, use the result of 'self defaultLabel_' "
	^ exception ifNil: [ self nullExceptionFor: context named: (label ifNil: [ self defaultLabel ]) ]
]

{ #category : #setter }
DebugRequest >> exception: anObject [
	exception := anObject
]

{ #category : #setter }
DebugRequest >> label: anObject [
	label := anObject
]

{ #category : #helper }
DebugRequest >> nullExceptionFor: aContext named: aString [
	| exception_ |
	exception_ := DebuggerSelectorNullException
		fromSignallerContext: aContext.
	exception_ messageText: aString.
	^ exception_
]

{ #category : #preDebugActions }
DebugRequest >> preDebugActionForDebugItMethod: aCompiledMethod [
	"Return a PreDebug action that will step the debugged execution until it is in a call to @aCompiledMethod"
	^ [ :session | 
	session
		stepIntoUntil: [ :currentContext | currentContext method == aCompiledMethod ] ]
]

{ #category : #getter }
DebugRequest >> preDebugActions [
	preDebugActions ifNil: [ preDebugActions := OrderedCollection new ].
	^ preDebugActions
]

{ #category : #getter }
DebugRequest >> process [
	"If a process was provided, return it, otherwise use the result of 'self defaultProcess'"
	^ process ifNil: [ self defaultProcess ]
]

{ #category : #setter }
DebugRequest >> process: anObject [
	process := anObject
]

{ #category : #submit }
DebugRequest >> submit [
	"Submit this debug request to the system. The system will typically open a debugger for it"
	DebuggerSystem handleDebugRequest: self
]
