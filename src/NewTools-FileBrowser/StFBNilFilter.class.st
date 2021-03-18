"
I am a filter that will not filter anything.

I am an implementation of nil object pattern.
"
Class {
	#name : #StFBNilFilter,
	#superclass : #StFBAbstractFilter,
	#category : #'NewTools-FileBrowser-Filtering'
}

{ #category : #accessing }
StFBNilFilter class >> priority [
	^ 150
]

{ #category : #accessing }
StFBNilFilter >> name [
	^ 'All'
]

{ #category : #accessing }
StFBNilFilter >> predicate: aFileReference [
	^ true
]
