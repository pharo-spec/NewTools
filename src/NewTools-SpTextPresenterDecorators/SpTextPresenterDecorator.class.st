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
		'interval'
	],
	#category : #'NewTools-SpTextPresenterDecorators'
}

{ #category : #accessing }
SpTextPresenterDecorator class >> defaultHighlightColor [
		
	^ Color orange alpha: 0.5
]

{ #category : #accessing }
SpTextPresenterDecorator class >> defaultUnderlineColor [
		
	^ Color white alpha: 0
]

{ #category : #'instance creation' }
SpTextPresenterDecorator class >> forHighlight [

	^ self new
		highlightColor: self defaultHighlightColor;
		underlineColor: self defaultUnderlineColor;	
		yourself
]

{ #category : #accessing }
SpTextPresenterDecorator class >> highlightStyleName [

	^ #highlight
]

{ #category : #accessing }
SpTextPresenterDecorator class >> underlineStyleName [

	^ #underline
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
SpTextPresenterDecorator >> interval: anInterval [

	interval := anInterval
]

{ #category : #accessing }
SpTextPresenterDecorator >> start [ 
	^interval first
]

{ #category : #accessing }
SpTextPresenterDecorator >> stop [ 
	^interval last
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
