Class {
	#name : 'StObjectContextPresenterTest',
	#superclass : 'StInspectorBaseTest',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'accessing' }
StObjectContextPresenterTest >> classToTest [

	^ StObjectContextPresenter
]

{ #category : 'initialization' }
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

{ #category : 'tests' }
StObjectContextPresenterTest >> testDoEvaluateAndGo [
	| evaluatedValue |

	self openInstance.
	
	presenter whenActivatedDo: [ :selection | evaluatedValue := selection value ].
	presenter evaluator text: '2*2'.
	
	presenter doEvaluateAndGo.
	
	self assert: evaluatedValue equals: 4
]

{ #category : 'tests' }
StObjectContextPresenterTest >> testDoEvaluateDeclareGlobal [
	| value |
	
	self skip: 'Because a change in the compiler API, there is no way to hijack OCUndeclaredVariableWarning when the compiler is used a in legacy interactive mode (but such hijack is only performed in this test). So disable the test for now.'.

	self deny: (Smalltalk globals includesKey: #MyGlobalForTest).
	
	self openInstance.
	
	presenter evaluator text: 'MyGlobalForTest'. 
	presenter whenActivatedDo: [ :selection | value := selection value ].

	[presenter doEvaluateAndGo] on: OCUndeclaredVariableWarning do: [ :warn | warn declareGlobal ].
	
	self assert: value equals:  nil.
	
	self assert: (Smalltalk globals includesKey: #MyGlobalForTest).
	Smalltalk globals removeKey: #MyGlobalForTest
]
