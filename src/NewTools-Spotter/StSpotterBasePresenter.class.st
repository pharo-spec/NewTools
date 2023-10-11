"
A base for presenters to be displayed as part of the spotter results list.
"
Class {
	#name : 'StSpotterBasePresenter',
	#superclass : 'SpPresenter',
	#category : 'NewTools-Spotter-View',
	#package : 'NewTools-Spotter',
	#tag : 'View'
}

{ #category : 'actions' }
StSpotterBasePresenter >> activateOn: spotterPresenter [

	self subclassResponsibility
]

{ #category : 'testing' }
StSpotterBasePresenter >> isHeader [

	^ false
]

{ #category : 'testing' }
StSpotterBasePresenter >> matchesText: aString [ 
	
	self subclassResponsibility
]

{ #category : 'accessing' }
StSpotterBasePresenter >> model [

	^ self subclassResponsibility
]
