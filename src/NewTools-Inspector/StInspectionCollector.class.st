Class {
	#name : #StInspectionCollector,
	#superclass : #Object,
	#instVars : [
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'as yet unclassified' }
StInspectionCollector class >> defaultExtensionPragmas [

	^ #(
	inspectorPresentationOrder:title:
	inspectorPresentationOrder:title:if:
	)
]

{ #category : #'instance creation' }
StInspectionCollector class >> on: anObject [

	^ self new 
		inspectedObject: anObject;
		yourself
]

{ #category : #accessing }
StInspectionCollector >> collectPages [ 
	| pragmas |
	
	pragmas := self extensionPragmas 
		inject: #()
		into: [ :all :each | all, (self collectPragmas: each) ].	

	^ (pragmas 
		sort: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ])
		select: [ :eachPragma | self pageShouldBeShown: eachPragma ] 
		thenCollect: [ :eachPragma | 
			SpNotebookPage 
				title: (eachPragma argumentAt: 2)
				provider: [ self inspectedObject perform: eachPragma methodSelector ] ]
]

{ #category : #private }
StInspectionCollector >> collectPragmas: aPragmaName [

	^ Pragma
		allNamed: aPragmaName
		from: self inspectedObject class
		to: ProtoObject
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
StInspectionCollector >> pageShouldBeShown: aPragma [
	| condition |
	
	aPragma numArgs < 3 ifTrue: [ ^ true ].
	
	"3rd argument is #if: and it needs to be a block with one argument"
	condition := aPragma argumentAt: 3.
	^ (condition isSymbol 
		ifTrue: [ condition ]
		ifFalse: [ self class compiler evaluate: condition ])
		value: self inspectedObject
]
