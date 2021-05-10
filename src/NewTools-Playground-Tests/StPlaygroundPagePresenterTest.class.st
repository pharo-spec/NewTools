Class {
	#name : #StPlaygroundPagePresenterTest,
	#superclass : #StPlaygroundBaseTest,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #accessing }
StPlaygroundPagePresenterTest >> classToTest [

	^ StPlaygroundPagePresenter
]

{ #category : #initialization }
StPlaygroundPagePresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: self newPage
]

{ #category : #'tests commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateAllAndGo [
	| value |
	
	self openInstance.
	
	presenter contents: '42 factorial'.
	presenter whenActivatedDo: [ :selection | value := selection value ].

	presenter doEvaluateAllAndGo.
	self 
		assert: value
		equals:  1405006117752879898543142606244511569936384000000000
]

{ #category : #'tests commands' }
StPlaygroundPagePresenterTest >> testDoEvaluateAndGo [
	| value |
	
	self openInstance.
	
	presenter contents: '42 factorial'.
	presenter whenActivatedDo: [ :selection | value := selection value ].

	presenter text selectionInterval: (1 to: 2).
	presenter doEvaluateAndGo.
	self 
		assert: value
		equals:  42.
			
	presenter text selectionInterval: (1 to: 12).
	presenter doEvaluateAndGo.
	self 
		assert: value
		equals:  1405006117752879898543142606244511569936384000000000
]
