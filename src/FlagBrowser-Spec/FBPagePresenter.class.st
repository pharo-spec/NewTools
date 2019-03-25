Class {
	#name : #FBPagePresenter,
	#superclass : #ComposablePresenter,
	#category : #'FlagBrowser-Spec'
}

{ #category : #accessing }
FBPagePresenter class >> allPages [
	^ self allSubclasses sorted: #priority ascending
]

{ #category : #specs }
FBPagePresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
]

{ #category : #specs }
FBPagePresenter class >> icon [
	^ self subclassResponsibility
]

{ #category : #accessing }
FBPagePresenter class >> priority [
	^ self subclassResponsibility
]

{ #category : #specs }
FBPagePresenter class >> title [
	^ self subclassResponsibility
]

{ #category : #initialization }
FBPagePresenter >> initializeWidgets [
	
]
