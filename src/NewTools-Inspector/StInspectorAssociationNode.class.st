Class {
	#name : #StInspectorAssociationNode,
	#superclass : #StInspectorNode,
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorAssociationNode class >> hostObject: anObject index: index [
	^ (self hostObject: anObject)
		index: index;
		yourself
]

{ #category : #accessing }
StInspectorAssociationNode >> key [

	^ self hostObject key
]

{ #category : #accessing }
StInspectorAssociationNode >> rawValue [

	^ self hostObject value
]

{ #category : #actions }
StInspectorAssociationNode >> save: aValue [
	self hostObject put: aValue
]

{ #category : #accessing }
StInspectorAssociationNode >> variableTag [
	^ 'association'
]
