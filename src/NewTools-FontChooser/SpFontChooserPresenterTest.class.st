Class {
	#name : #SpFontChooserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #running }
SpFontChooserPresenterTest >> setUp [

	| fontChooser |
	fontChooser := FontChooser newWithDefaultFamilies
		font: (LogicalFont familyName: 'Bitmap DejaVu Sans' pointSize: 12);
		yourself.
	
	presenter := SpFontChooserPresenter on: fontChooser.
	
]

{ #category : #tests }
SpFontChooserPresenterTest >> testFamilyListCorrectAtInitialization [

	self deny: presenter fontFamilyList items isEmpty.
	self assert: presenter fontFamilyList items size equals: 3.
	self assert: presenter fontFamilyList selectedItems equals: { presenter fontFamilyList items first}.
	self assert: (presenter fontFamilyList displayValueAt: 1) equals: 'Bitmap DejaVu Sans'
]

{ #category : #tests }
SpFontChooserPresenterTest >> testFirstStyleIsSelected [
	
	self assert: (presenter fontStyleList selectedItems collect: [:each | each styleName ]) equals: #('Regular')
]

{ #category : #tests }
SpFontChooserPresenterTest >> testPresenterOpenAndClose [
	
	self shouldnt: [ 
			| window | 
			window := presenter openWithSpec.
			window close ] raise: Error
]

{ #category : #'tests - keep selection' }
SpFontChooserPresenterTest >> testSelectionInFontStyleListIsKept [


	presenter fontStyleList clickItem: 3.
	presenter fontFamilyList clickItem: 2.
	 
	self assert: presenter fontStyleList selection selectedIndex equals: 3
]

{ #category : #'tests - keep selection' }
SpFontChooserPresenterTest >> testSelectionInFontStyleListIsKept2 [

	| string |
	presenter fontStyleList clickItem: 3.
	string := (presenter fontStyleList displayValueAt: 3). "for example 'Bold'"
	presenter fontFamilyList clickItem: 2.
	
	self assert: presenter fontStyleList selection selectedItem styleName equals: string
]

{ #category : #tests }
SpFontChooserPresenterTest >> testStyleIsDisplayed [
	
	self assert: presenter fontStyleList items size equals: #('Regular' 'Italic' 'Bold' 'Bold Italic') size
]
