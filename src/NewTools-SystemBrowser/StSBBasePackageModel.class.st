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
StSBBasePackageModel >> classTemplate [

	self flag: #TODO. "Maybe extract this into its own creation tool, as Calypso 1?"
	^ 'Object subclass: #NameOfSubclass
	slots: {}
	classVariables: {}
	package: ''', self fullName, ''''
]

{ #category : #accessing }
StSBBasePackageModel >> classes [

	^ self subclassResponsibility
]

{ #category : #accessing }
StSBBasePackageModel >> comment [

	^ self package packageComment
]

{ #category : #accessing }
StSBBasePackageModel >> fullName [

	^ self name
]

{ #category : #accessing }
StSBBasePackageModel >> package [

	^ self subclassResponsibility
]

{ #category : #accessing }
StSBBasePackageModel >> windowTitle [
	
	^ 'Package: ', self name
]
