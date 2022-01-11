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
	self 
		assert: chooser fontList first familyName 
		equals: LogicalFontManager current defaultFamilies first familyName
	
]
