"
To open the old font chooser morph

```
FontChooser
	openWithWindowTitle: 'Choose the Menu Font'
	for: StandardFonts
	setSelector: #menuFont:
	getSelector: #menuFont

```
"
Class {
	#name : #FontChooserTest,
	#superclass : #TestCase,
	#instVars : [
		'chooser'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #tests }
FontChooserTest >> setUp [
	
	chooser := FontChooser new.
	chooser fontList: LogicalFontManager current defaultFamilies.
	"this is equivalent to FontChooser newWithDefaultFamilies"

]

{ #category : #tests }
FontChooserTest >> testFontList [
	
	self deny: chooser fontList isEmpty.
	self assert: chooser fontList first familyName equals: LogicalFontManager current defaultFamilies first familyName
	
]

{ #category : #tests }
FontChooserTest >> testFontListStrings [

	self deny: chooser fontListStrings isEmpty.
	self 
		assert: chooser fontListStrings
		equals: (LogicalFontManager current defaultFamilies collect: [ :each | each familyName ]) 
]
