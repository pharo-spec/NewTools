Class {
	#name : #FDFileFilterTest,
	#superclass : #FDAbstractFilterTest,
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #accessing }
FDFileFilterTest >> actualClass [
	^ FDFileFilter
]

{ #category : #tests }
FDFileFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: (root children select: #isFile)
]
