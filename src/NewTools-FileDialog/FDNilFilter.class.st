"
I am a filter that will not filter anything.

I am an implementation of nil object pattern.
"
Class {
	#name : #FDNilFilter,
	#superclass : #FDAbstractFilter,
	#category : #'NewTools-FileDialog-Filtering'
}

{ #category : #accessing }
FDNilFilter class >> priority [
	^ 150
]

{ #category : #accessing }
FDNilFilter >> name [
	^ 'All'
]

{ #category : #accessing }
FDNilFilter >> predicate: aFileReference [
	^ true
]
