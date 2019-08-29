"
Description
--------------------

I represent a tab of the FlagBrowser. 

We different subclasses will organize flags in different ways.
"
Class {
	#name : #FBPagePresenter,
	#superclass : #SpPresenter,
	#category : #'NewTools-FlagBrowser-Presenters'
}

{ #category : #accessing }
FBPagePresenter class >> allPages [
	^ (self allSubclasses reject: #isAbstract) sorted: #priority ascending
]

{ #category : #specs }
FBPagePresenter class >> icon [
	^ self subclassResponsibility
]

{ #category : #testing }
FBPagePresenter class >> isAbstract [
	^ self = FBPagePresenter
]

{ #category : #accessing }
FBPagePresenter class >> priority [
	^ self subclassResponsibility
]

{ #category : #specs }
FBPagePresenter class >> title [
	^ self subclassResponsibility
]
