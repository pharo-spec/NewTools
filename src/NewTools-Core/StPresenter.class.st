Class {
	#name : #StPresenter,
	#superclass : #SpPresenter,
	#category : #'NewTools-Core'
}

{ #category : #private }
StPresenter class >> currentApplication [

	^ StPharoApplication current
]

{ #category : #'instance creation' }
StPresenter class >> new [

	^ self newApplication: self currentApplication
]

{ #category : #'instance creation' }
StPresenter class >> on: anObject [ 

	^ self 
		newApplication: self currentApplication
		model: anObject
]

{ #category : #'instance creation' }
StPresenter class >> owner: anOwningPresenter [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
]

{ #category : #'instance creation' }
StPresenter class >> owner: anOwningPresenter on: aDomainObject [

	^ self 
		newApplication: self currentApplication
		owner: anOwningPresenter
		model: aDomainObject
]

{ #category : #accessing }
StPresenter class >> preferredExtent [

	^ 600@400
]

{ #category : #initialization }
StPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter initialExtent: self preferredExtent	
]

{ #category : #initialization }
StPresenter >> preferredExtent [

	^ self class preferredExtent
]
