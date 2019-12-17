"
I specify segment decorations for text presenters.
Adapters must transform me to text segment compatible with the target backend.

For now, I can be composed of two styles, #highlight and #underlined.

"
Class {
	#name : #SpTextPresenterDecorator,
	#superclass : #Object,
	#instVars : [
		'highlightColor',
		'underlineColor',
		'borderColor',
		'icon',
		'iconBlock',
		'title',
		'styles',
		'interval'
	],
	#category : #'NewTools-SpTextPresenterDecorators'
}

{ #category : #'as yet unclassified' }
SpTextPresenterDecorator class >> highlightStyleName [
	^#highlight
]

{ #category : #'as yet unclassified' }
SpTextPresenterDecorator class >> underlineStyleName [
	^#underline
]

{ #category : #styles }
SpTextPresenterDecorator >> addHighlightDecoration [
	self styles add: self class highlightStyleName
]

{ #category : #styles }
SpTextPresenterDecorator >> addUnderlineDecoration [
	self styles add: self class underlineStyleName
]

{ #category : #accessing }
SpTextPresenterDecorator >> borderColor [
	^ borderColor
]

{ #category : #accessing }
SpTextPresenterDecorator >> borderColor: anObject [
	borderColor := anObject
]

{ #category : #accessing }
SpTextPresenterDecorator >> highlightColor [
	^ highlightColor
]

{ #category : #accessing }
SpTextPresenterDecorator >> highlightColor: anObject [
	highlightColor := anObject
]

{ #category : #accessing }
SpTextPresenterDecorator >> icon [
	^ icon
]

{ #category : #accessing }
SpTextPresenterDecorator >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
SpTextPresenterDecorator >> iconBlock [
	^ iconBlock
]

{ #category : #accessing }
SpTextPresenterDecorator >> iconBlock: anObject [
	iconBlock := anObject
]

{ #category : #accessing }
SpTextPresenterDecorator >> interval [
	^ interval
]

{ #category : #accessing }
SpTextPresenterDecorator >> interval: anObject [
	interval := anObject
]

{ #category : #styles }
SpTextPresenterDecorator >> removeHighlightDecoration [
	self styles remove: self class highlightStyleName ifAbsent: [  ]
]

{ #category : #styles }
SpTextPresenterDecorator >> removeUnderlineDecoration [
	self styles remove: self class underlineStyleName ifAbsent: [  ]
]

{ #category : #accessing }
SpTextPresenterDecorator >> styles [
	^ styles ifNil: [ styles := Set new ]
]

{ #category : #accessing }
SpTextPresenterDecorator >> title [
	^ title
]

{ #category : #accessing }
SpTextPresenterDecorator >> title: anObject [
	title := anObject
]

{ #category : #accessing }
SpTextPresenterDecorator >> underlineColor [
	^ underlineColor
]

{ #category : #accessing }
SpTextPresenterDecorator >> underlineColor: anObject [
	underlineColor := anObject
]
