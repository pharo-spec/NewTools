Class {
	#name : 'StFontChooserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-FontChooser',
	#package : 'NewTools-FontChooser'
}

{ #category : 'running' }
StFontChooserPresenterTest >> newAllFamilyFontChooser: aFamilyName [

	^ FontChooser newWithAllFamilies
		font: (LogicalFont familyName: aFamilyName pointSize: 12);
		yourself.	
]

{ #category : 'running' }
StFontChooserPresenterTest >> newAllFamilyFontChooserFont: aLogicalFont [

	^ FontChooser newWithAllFamilies
		font: aLogicalFont;
		yourself.	
]

{ #category : 'running' }
StFontChooserPresenterTest >> newDefaultFamilyFontChooser: aFamilyName [

	^ self newDefaultFamilyFontChooserFont: (LogicalFont familyName: aFamilyName pointSize: 12)
]

{ #category : 'running' }
StFontChooserPresenterTest >> newDefaultFamilyFontChooserFont: aLogicalFont [

	^ FontChooser newWithDefaultFamilies
		font: aLogicalFont;
		yourself.	
]

{ #category : 'running' }
StFontChooserPresenterTest >> setUp [

	| fontChooser |
	
	super setUp.
	
	fontChooser := self newDefaultFamilyFontChooser: 'Bitmap DejaVu Sans'.
	
	presenter := StFontChooserPresenter on: fontChooser.
	
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testFamilyListCorrectAtInitialization [

	self deny: presenter fontFamilyList items isEmpty.
	self assert: presenter fontFamilyList items size equals: 3.
	self assert: presenter fontFamilyList selectedItems equals: { presenter fontFamilyList items first}.
	self assert: (presenter fontFamilyList displayValueAt: 1) equals: 'Bitmap DejaVu Sans'
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testFirstStyleIsSelected [
	
	self assert: (presenter fontStyleList selectedItems collect: [:each | each styleName ]) equals: #('Regular')
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testOpenAllOnNonExistantFontFamily [

	| fontChooser |

	fontChooser := self newAllFamilyFontChooser: 'dd08sadna80nsazczxcz'.
	presenter := StFontChooserPresenter on: fontChooser.

	self shouldnt: [ 
			| window | 
			window := presenter open.
			window close ] raise: Error
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testOpenAllOnUnloadedFontFamily [

	| fontChooser |

	fontChooser := self newAllFamilyFontChooser: 'Arial'.
	presenter := StFontChooserPresenter on: fontChooser.

	self shouldnt: [ 
			| window | 
			window := presenter open.
			window close ] raise: Error
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testOpenDefaultOnNonExistantFontFamily [

	| fontChooser |

	fontChooser := self newDefaultFamilyFontChooser: 'dd08sadna80nsazczxcz'.
	presenter := StFontChooserPresenter on: fontChooser.

	self shouldnt: [ 
			| window | 
			window := presenter open.
			window close ] raise: Error
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testOpenDefaultOnUnloadedFontFamily [

	| fontChooser |

	fontChooser := self newDefaultFamilyFontChooser: 'Arial'.
	presenter := StFontChooserPresenter on: fontChooser.

	self shouldnt: [ 
			| window | 
			window := presenter open.
			window close ] raise: Error
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testPresenterOpenAndClose [
	
	self shouldnt: [ 
			| window | 
			window := presenter open.
			window close ] raise: Error
]

{ #category : 'tests - keep selection' }
StFontChooserPresenterTest >> testSelectionInFontStyleListIsKept [


	presenter fontStyleList clickItem: 3.
	presenter fontFamilyList clickItem: 2.
	 
	self assert: presenter fontStyleList selection selectedIndex equals: 3
]

{ #category : 'tests - keep selection' }
StFontChooserPresenterTest >> testSelectionInFontStyleListIsKept2 [

	| string |
	presenter fontStyleList clickItem: 3.
	string := (presenter fontStyleList displayValueAt: 3). "for example 'Bold'"
	presenter fontFamilyList clickItem: 2.
	
	self assert: presenter fontStyleList selection selectedItem styleName equals: string
]

{ #category : 'tests' }
StFontChooserPresenterTest >> testStyleIsDisplayed [
	
	self assert: presenter fontStyleList items size equals: #('Regular' 'Italic' 'Bold' 'Bold Italic') size
]
