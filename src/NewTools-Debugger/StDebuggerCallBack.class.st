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
StDebuggerCallBack >> confirm: message [
	"call back method to avoid dependencies in debugger-model"

	^ presenter confirm: message
]

{ #category : 'accessing' }
StDebuggerCallBack >> presenter [

	^ presenter
]

{ #category : 'accessing' }
StDebuggerCallBack >> presenter: anObject [

	presenter := anObject
]
