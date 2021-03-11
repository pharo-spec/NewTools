Class {
	#name : #NewFontChooserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'chooser'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #tests }
NewFontChooserModelTest >> setUp [
	
	chooser := NewFontChooserModel new.
	chooser fontList: LogicalFontManager current defaultFamilies.
	"this is equivalent to FontChooser newWithDefaultFamilies"

]

{ #category : #tests }
NewFontChooserModelTest >> testFontList [
	
	self deny: chooser fontList isEmpty.
	self 
		assert: chooser fontList first familyName 
		equals: LogicalFontManager current defaultFamilies first familyName
	
]
