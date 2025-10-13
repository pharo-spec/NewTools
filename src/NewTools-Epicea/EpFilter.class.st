"
My instances decide if an OmEntry is accepted.
"
Class {
	#name : 'EpFilter',
	#superclass : 'Object',
	#category : 'NewTools-Epicea-Filters',
	#package : 'NewTools-Epicea',
	#tag : 'Filters'
}

{ #category : 'filtering' }
EpFilter >> accepts: anEntry [
	^ self subclassResponsibility
]
