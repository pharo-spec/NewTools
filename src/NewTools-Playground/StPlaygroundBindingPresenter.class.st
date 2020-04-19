Class {
	#name : #StPlaygroundBindingPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'binding'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlaygroundBindingPresenter >> binding [

	^ binding
]

{ #category : #initialization }
StPlaygroundBindingPresenter >> initializePresenters [

	layout := SpBoxLayout newHorizontal
		add: binding key asString;
		addLast: (self newButton
			icon: (self application iconNamed: #glamorousClose);
			action: [ "" ];
			yourself);
		yourself
]

{ #category : #'accessing model' }
StPlaygroundBindingPresenter >> setModelBeforeInitialization: aBinding [

	binding := aBinding
]
