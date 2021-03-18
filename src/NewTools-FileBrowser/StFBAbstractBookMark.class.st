"
i'm an Abstract class to 

my subclass must define:

isComposite : return Boolean

IV :

icon <Form> 
name <Form> 
"
Class {
	#name : #StFBAbstractBookMark,
	#superclass : #Object,
	#instVars : [
		'name',
		'icon'
	],
	#category : #'NewTools-FileBrowser-Bookmark'
}

{ #category : #accessing }
StFBAbstractBookMark >> children [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
StFBAbstractBookMark >> icon [
	^ icon
]

{ #category : #accessing }
StFBAbstractBookMark >> icon: anObject [
	icon := anObject
]

{ #category : #testing }
StFBAbstractBookMark >> isComposite [
	^ self subclassResponsibility.
]

{ #category : #accessing }
StFBAbstractBookMark >> name [
	^ name
]

{ #category : #accessing }
StFBAbstractBookMark >> name: anObject [
	name := anObject
]
