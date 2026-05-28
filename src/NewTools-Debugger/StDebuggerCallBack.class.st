"
A class made for debugger's call backs 
"
Class {
	#name : 'StDebuggerCallBack',
	#superclass : 'Object',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'callbacks' }
StDebuggerCallBack >> chooseTraitOverwriteFor: aClass trait: aTrait [
	"call back method to avoid dependencies in debugger-model"

	| dialog selection |
	dialog := presenter application newSelect
		          title: 'Where do you want to compile this trait method ?';
		          items: {
				          aClass.
				          aTrait };
		          display: [ :each | 
				          each == aClass
					          ifTrue: [ 'Create copy in ' , aClass name ]
					          ifFalse: [ 'Compile Trait method in ' , aTrait name ] ].

	selection := dialog openModal.

	^ selection

]

{ #category : 'callbacks' }
StDebuggerCallBack >> informCannotRecompileWithDifferentSelector [

	presenter inform: 'Cannot recompile method with different selector'
]

{ #category : 'callbacks' }
StDebuggerCallBack >> informCannotRewindStack [

	presenter inform: 'Method saved, but current context unchanged\because of unwind error. Click OK to see error' withCRs
]

{ #category : 'accessing' }
StDebuggerCallBack >> presenter [

	^ presenter
]

{ #category : 'accessing' }
StDebuggerCallBack >> presenter: anObject [

	presenter := anObject
]

{ #category : 'callbacks' }
StDebuggerCallBack >> wantsToBroweAndRecompileMethodNotFoundInStack: aMethod [
	"call back method to avoid dependencies in debugger-model"

	| message |
	message := 'Method for block not found on stack, can''t edit and continue. Do you want to browse and recompile ? '.

	aMethod selector isDoIt ifTrue: [
			presenter inform: message.
			^ false ].

	^ presenter confirm: message
]
