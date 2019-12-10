Class {
	#name : #StDebuggerInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'inspector',
		'model',
		'label'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerInspector class >> defaultSpec [
	^ SpBoxLayout newVertical
		  add: #inspector;
		  yourself
]

{ #category : #'instance creation' }
StDebuggerInspector class >> openOn: anObject [

	^ (self on: (StInspectorModel on: anObject)) openWithSpec
]

{ #category : #specs }
StDebuggerInspector class >> title [
	 ^'Debugger Inspection'
]

{ #category : #initialization }
StDebuggerInspector >> initializePresenters [
	label := self newLabel.
	inspector := self instantiate: StInspector on: self model
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [

	^ self model inspectedObject
]

{ #category : #accessing }
StDebuggerInspector >> label: aString [

	label label: aString
]

{ #category : #'accessing model' }
StDebuggerInspector >> model [

	^ model
]

{ #category : #'accessing model' }
StDebuggerInspector >> model: aModel [

	model := aModel.
	inspector model: model
]

{ #category : #'accessing model' }
StDebuggerInspector >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : #updating }
StDebuggerInspector >> updateEvaluationPaneReceiver [

	|receiver evaluator|
	receiver := self model inspectedObject context receiver.
	evaluator := inspector millerList presenters first evaluator.
	evaluator doItReceiver: receiver.
	evaluator behavior: receiver class.
]

{ #category : #updating }
StDebuggerInspector >> updateWith: inspectedObject [
	| oldPath oldItem |

	self flag: 'Suspicious test: should not be == ?'.
	self model inspectedObject = inspectedObject ifTrue: [ ^ self ].
"
	oldPath := inspector selectedPath.
	oldItem := inspector selectedItem hostObject.
"
	self model: (StDebuggerInspectorModel on: inspectedObject).
	self updateEvaluationPaneReceiver.
	
"	inspectedObject == oldItem 
		ifTrue: [ inspector selectPath: oldPath ]
		ifFalse: [ inspector selectFirst ]"
]
