"
I am the model to use the SpFontChooserPresenter.
Users will use me directly.
Check the constructors in the class side to see how to use me.
I can be used in modal and non-modal way.
"
Class {
	#name : #FontChooser,
	#superclass : #Model,
	#instVars : [
		'fontList',
		'title',
		'font',
		'onAcceptDo'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #enumerating }
FontChooser class >> example [

	<script>

	self
		openWithTitle: 'Choose the Menu Font'
		initialFont: StandardFonts menuFont
		onAcceptDo: [ :aFont | aFont inspect ]
]

{ #category : #'instance creation' }
FontChooser class >> newWithAllFamilies [

   ^ self new fontList: LogicalFontManager current allFamilies; yourself
]

{ #category : #'instance creation' }
FontChooser class >> newWithDefaultFamilies [

   ^ self new fontList: LogicalFontManager current defaultFamilies; yourself
]

{ #category : #enumerating }
FontChooser class >> openModalWithTitle: aTitle initialFont: aFont onAcceptDo: aBlock [

	^ self openWithTitle: aTitle initialFont: aFont onAcceptDo: aBlock modal: true.
	
]

{ #category : #enumerating }
FontChooser class >> openWithTitle: aTitle initialFont: aFont onAcceptDo: aBlock [

	^ self openWithTitle: aTitle initialFont: aFont onAcceptDo: aBlock modal: false
]

{ #category : #enumerating }
FontChooser class >> openWithTitle: aTitle initialFont: aFont onAcceptDo: aBlock modal: isModal [

	| instance presenter |
	instance := self newWithAllFamilies.
	
	instance
		title: aTitle;
		font: aFont;
		onAcceptDo: aBlock.
	
	presenter := StFontChooserPresenter on: instance.
	
	isModal 
		ifTrue: [presenter openModalWithSpec]
		ifFalse: [presenter openDialogWithSpec].
		
	^ instance
]

{ #category : #accessing }
FontChooser >> font [
	^ font
]

{ #category : #accessing }
FontChooser >> font: aLogicalFont [ 
	
	font := aLogicalFont
]

{ #category : #accessing }
FontChooser >> fontList [
	^ fontList
]

{ #category : #accessing }
FontChooser >> fontList: aCollection [ 
	fontList := aCollection
]

{ #category : #accessing }
FontChooser >> onAcceptDo [
	^ onAcceptDo
]

{ #category : #accessing }
FontChooser >> onAcceptDo: aFullBlockClosure [ 
	
	onAcceptDo := aFullBlockClosure 
]

{ #category : #accessing }
FontChooser >> title [
	^ title
]

{ #category : #accessing }
FontChooser >> title: aString [ 
	
	title := aString
]
