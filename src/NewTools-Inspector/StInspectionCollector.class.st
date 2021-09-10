"
I collect inspections from an object which wants to be inspected.
I traverse the hierarchy of the object collecting #extensionPragmas and applying them.

For now, I have two pragmas that receive 2 or 3 arguments: 

- inspectorPresentationOrder:title:
- inspectorPresentationOrder:title:if:

order: inspection appearance order
title: inspection title
if: a block receiving ONE argument that will be evaluated to determine if that inspection needs to be shown.

The arguments of the pragmas are required because the tabs are calculated lazily and this information 
is required before.
"
Class {
	#name : #StInspectionCollector,
	#superclass : #Object,
	#instVars : [
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #defaults }
StInspectionCollector class >> defaultExtensionPragmas [

	^ #(inspectorPresentationOrder:title:)
]

{ #category : #'instance creation' }
StInspectionCollector class >> on: anObject [

	^ self new 
		inspectedObject: anObject;
		yourself
]

{ #category : #private }
StInspectionCollector >> basicContextFromPragma: aPragma [
	"Get the context for a pragma or fail if an error happens"
	| context |
	
	context := StInspectionContext fromPragma: aPragma.
	context inspectedObject: self inspectedObject.

	(self inspectedObject respondsTo: context contextMethodSelector) ifTrue: [ 
		self inspectedObject 
			perform: context contextMethodSelector
			with: context ].

	^ context
]

{ #category : #accessing }
StInspectionCollector >> collectInspectionContexts [
	| pragmas |
	
	pragmas := self uniquePragmas: (self extensionPragmas
		inject: #()
		into: [ :all :each | all, (self collectPragmas: each) ]).

	^ (pragmas 
		collect: [ :each | self contextFromPragma: each ]
		thenSelect: [ :each | each isActive ])
		sorted: #order ascending
]

{ #category : #private }
StInspectionCollector >> collectPragmas: aPragmaName [

	^ Pragma
		allNamed: aPragmaName
		from: self inspectedObject class
		to: ProtoObject
]

{ #category : #private }
StInspectionCollector >> contextFromPragma: aPragma [
	"Return the inspection context for a pragma.
	Safe version: Return an error context if the context cannot be obtained"
	[ ^ self basicContextFromPragma: aPragma ]
		on: Exception
		do: [ :error | 
			^ (StErrorContext fromPragma: aPragma)
				  inspectedObject: self inspectedObject;
				  setError: error freeze;
				  yourself ]
]

{ #category : #private }
StInspectionCollector >> extensionPragmas [

	^ self class defaultExtensionPragmas
]

{ #category : #accessing }
StInspectionCollector >> inspectedObject [
	^ inspectedObject
]

{ #category : #accessing }
StInspectionCollector >> inspectedObject: anObject [
	inspectedObject := anObject
]

{ #category : #private }
StInspectionCollector >> uniquePragmas: aCollection [
	| unique |
	
	unique := OrderedDictionary new.
	aCollection do: [ :each |
		unique
			at: each methodSelector
			ifAbsentPut: [ each ] ].
	^ unique values
]
