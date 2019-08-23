"
I'm selecting all
"
Class {
	#name : #FDDefaultFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'NewTools-FileDialog-filterStrategie'
}

{ #category : #applying }
FDDefaultFilter >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference
]

{ #category : #accessing }
FDDefaultFilter >> name [
	^ 'no filter'
]

{ #category : #accessing }
FDDefaultFilter >> predicate: aFileReference [
	^ true
]
