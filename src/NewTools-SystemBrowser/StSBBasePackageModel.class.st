Class {
	#name : #StSBBasePackageModel,
	#superclass : #StSBModel,
	#category : #'NewTools-SystemBrowser'
}

{ #category : #accessing }
StSBBasePackageModel >> children [

	^ self subclassResponsibility
]

{ #category : #accessing }
StSBBasePackageModel >> classes [

	^ self subclassResponsibility
]
