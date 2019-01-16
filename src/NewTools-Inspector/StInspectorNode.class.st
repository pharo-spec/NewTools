Class {
	#name : #StInspectorNode,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #accessing }
StInspectorNode class >> defaultStringLimit [

	^ 500
]

{ #category : #accessing }
StInspectorNode >> children [

	^ #()
]

{ #category : #accessing }
StInspectorNode >> icon [ 

	^ [ 
		(self value inspectorIcon) ifNil: [ 
			self value class systemIcon ] ]
	on: Error do: [ :error | 
		self iconError: error ]
]

{ #category : #private }
StInspectorNode >> iconError: error [
	
	^ self iconNamed: #smallWarningIcon

]

{ #category : #accessing }
StInspectorNode >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
StInspectorNode >> object [
	^ object
]

{ #category : #private }
StInspectorNode >> object: anObject [

	object := anObject
]

{ #category : #accessing }
StInspectorNode >> stringLimit [

	^ self class defaultStringLimit
]

{ #category : #accessing }
StInspectorNode >> stringValue [ 

	"^ self value printStringLimitedTo: self stringLimit"
	^ self value inspectorDisplayString
]

{ #category : #accessing }
StInspectorNode >> value [

	^ self subclassResponsibility
]
