"
A subclass of easy column, used for test icon view
"
Class {
	#name : 'StTestIconColumnView',
	#superclass : 'SpEasyColumnViewColumn',
	#instVars : [
		'executeBlock'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
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
