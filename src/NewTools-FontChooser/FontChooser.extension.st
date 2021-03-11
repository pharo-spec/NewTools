Extension { #name : #FontChooser }

{ #category : #'*NewTools-FontChooser' }
FontChooser >> fontList: aFontList [
	
	fontList := aFontList
]

{ #category : #'*NewTools-FontChooser' }
FontChooser >> fontListStrings: aFontList [
	
	fontListStrings := aFontList
]

{ #category : #'*NewTools-FontChooser' }
FontChooser class >> newWithDefaultFamilies [

   ^ self new fontList: LogicalFontManager current defaultFamilies; yourself
]
