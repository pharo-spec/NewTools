Class {
	#name : #FBByClassesPagePresenter,
	#superclass : #FBPagePresenter,
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByClassesPagePresenter class >> icon [
	^ #class
]

{ #category : #accessing }
FBByClassesPagePresenter class >> priority [
	^ 10
]

{ #category : #specs }
FBByClassesPagePresenter class >> title [
	^ 'By class'
]
