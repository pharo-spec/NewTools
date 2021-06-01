Class {
	#name : #StObjectContextPresenterTest,
	#superclass : #StInspectorBaseTest,
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #accessing }
StObjectContextPresenterTest >> classToTest [

	^ StObjectContextPresenter
]

{ #category : #initialization }
StObjectContextPresenterTest >> initializeInstanceBeforeInitialization: aPresenter [
	| model context |

	model := StInspectorModel on: StInspectorMockObject new.
	context := StInspectionContext fromPragma: (StInspectorMockObject>>#inspectionMock1) pragmas first.
	context inspectedObject: model inspectedObject.
	aPresenter setModelBeforeInitialization: (StObjectContextModel new 
		inspection: model;
		inspectedObject: model inspectedObject;
		context: context; 
		yourself)
]

{ #category : #tests }
StObjectContextPresenterTest >> testDoEvaluateAndGo [
	| evaluatedValue |

	self openInstance.
	
	presenter whenActivatedDo: [ :selection | evaluatedValue := selection value ].
	presenter evaluator text: '2*2'.
	
	presenter doEvaluateAndGo.
	
	self assert: evaluatedValue equals: 4
]
