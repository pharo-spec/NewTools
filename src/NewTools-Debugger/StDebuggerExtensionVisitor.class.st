"
This class provides hooks, which do nothing, to visit debugger extensions.

To define a debugger extension visitor, you must create a subclass of this class and override the `visitXXX` hook for the debugger extensions that you want.

If you want to define a new debugger extension that is visited by debugger visitors, you must define an extension method as a hook for you new extension: `visitNewExtension` and define in your debugger extension class:

```language=Pharo
NewExtension>>#accept: aVisitor
	^ aVisitor visitNewExtension: self
```
"
Class {
	#name : #StDebuggerExtensionVisitor,
	#superclass : #Object,
	#instVars : [
		'result'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #initialization }
StDebuggerExtensionVisitor >> initialize [ 

	super initialize.
	self initializeResult
]

{ #category : #initialization }
StDebuggerExtensionVisitor >> initializeResult [

	self subclassResponsibility 
]

{ #category : #accessing }
StDebuggerExtensionVisitor >> result [

	^ result
]

{ #category : #visiting }
StDebuggerExtensionVisitor >> visit: aStDebuggerExtension [

	aStDebuggerExtension accept: self
]

{ #category : #visiting }
StDebuggerExtensionVisitor >> visitBreakpoints: aBreakpointsExtension [
]

{ #category : #visiting }
StDebuggerExtensionVisitor >> visitBytecode: aBytecodeExtension [
]

{ #category : #visiting }
StDebuggerExtensionVisitor >> visitSindarin: aSindarinExtension [
]
