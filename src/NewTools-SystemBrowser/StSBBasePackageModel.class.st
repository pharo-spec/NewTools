Class {
	#name : #StSBBasePackageModel,
	#superclass : #StSBModel,
	#category : #'NewTools-SystemBrowser-Model'
}

{ #category : #accessing }
StSBBasePackageModel >> children [

	^ self subclassResponsibility
]

{ #category : #accessing }
StSBBasePackageModel >> classes [

	^ self subclassResponsibility
]
