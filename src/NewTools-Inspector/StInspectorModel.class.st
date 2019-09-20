Class {
	#name : #StInspectorModel,
	#superclass : #Object,
	#instVars : [
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorModel class >> new [ 

	self error: 'Use #on:'
]

{ #category : #'instance creation' }
StInspectorModel class >> on: anObject [

	^ super new inspectedObject: anObject
]

{ #category : #accessing }
StInspectorModel >> debuggerInspectorNodes [

	^ self inspectedObject debuggerInspectorNodes
]

{ #category : #accessing }
StInspectorModel >> descriptionString [
	| header printString object |
	
	object := self inspectedObject.
	header := (object class name first isVowel
		ifTrue: [ 'an ' ]
		ifFalse: [ 'a ' ]) , 
		object class name.
	
	printString := (GTObjectPrinter asTruncatedTextFrom: object) asString.
	^ (printString beginsWith: header)
		ifTrue: [ printString ]
		ifFalse: [ 
			String streamContents: [ :out | 
				out << header; << ' ('; << printString; << ')' ] ]
]

{ #category : #accessing }
StInspectorModel >> inspectedObject [

	^ inspectedObject
]

{ #category : #accessing }
StInspectorModel >> inspectedObject: anObject [
	inspectedObject := anObject
]

{ #category : #accessing }
StInspectorModel >> objectInspectionPages [

	^ self inspectedObject inspectionPages
]

{ #category : #accessing }
StInspectorModel >> windowTitle [

	^ 'Inspector on {1}' format: { self inspectedObject gtDisplayString }
]
