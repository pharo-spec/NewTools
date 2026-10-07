"
A subclass of easy column, used for test icon view
"
Class {
	#name : 'StTestIconColumnView',
	#superclass : 'SpEasyColumnViewColumn',
	#instVars : [
		'executeBlock'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
}

{ #category : 'accessing' }
StTestIconColumnView >> executeBlock: aBlock [

	executeBlock := aBlock
]

{ #category : 'initialization' }
StTestIconColumnView >> initialize [

	super initialize.
	self bind: [ :aPresenter :anObject |
			aPresenter model: anObject.
			aPresenter onExecute: executeBlock ]
]
