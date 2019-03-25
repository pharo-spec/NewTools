Class {
	#name : #FBByPackagesPagePresenter,
	#superclass : #FBPagePresenter,
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByPackagesPagePresenter class >> icon [
	^ #package
]

{ #category : #accessing }
FBByPackagesPagePresenter class >> priority [
	^ 5
]

{ #category : #specs }
FBByPackagesPagePresenter class >> title [
	^ 'By package'
]
