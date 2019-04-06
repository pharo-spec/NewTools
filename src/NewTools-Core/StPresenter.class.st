Class {
	#name : #StPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'menuHolder',
		'toolbarHolder',
		'statusBarHolder'
	],
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
