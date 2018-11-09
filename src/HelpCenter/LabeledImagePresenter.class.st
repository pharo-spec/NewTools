Class {
	#name : #LabeledImagePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'picture',
		'caption'
	],
	#category : #'HelpCenter-widgets'
}

{ #category : #specs }
LabeledImagePresenter class >> defaultSpec [ 
	^SpecLayout composed
		newRow: [ :row | row add: #picture; add: #caption ] origin: 0 @ 0 corner: 1 @ 1;
		yourself
]

{ #category : #accessing }
LabeledImagePresenter >> caption [
	^ caption
]

{ #category : #accessing }
LabeledImagePresenter >> caption: anObject [
	caption := anObject
]

{ #category : #initialize }
LabeledImagePresenter >> initializePresenter [
]

{ #category : #initialize }
LabeledImagePresenter >> initializeWidgets [ 
	picture := self newImage.
	"linkPresenter ?"
	caption := self newLabel.
	
	caption label: 'Texte du lien'.
	
	picture image: (self iconNamed: #user).
	picture inspect.
	picture extent: 128 @ 128.
	picture extent inspect.
]

{ #category : #accessing }
LabeledImagePresenter >> picture [
	^ picture
]

{ #category : #accessing }
LabeledImagePresenter >> picture: anObject [
	picture := anObject
]

{ #category : #initialize }
LabeledImagePresenter >> title [
	^'LabelImagePresenter'
]
