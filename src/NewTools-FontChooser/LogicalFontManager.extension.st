Extension { #name : #LogicalFontManager }

{ #category : #'*NewTools-FontChooser' }
LogicalFontManager >> defaultFamilies [
	"answer an Array containing the default TextStyle font families, sorted by family name"

	| textStyleFamilies |
	textStyleFamilies := TextStyle knownTextStylesWithoutDefault
		collect: [ :textStyleName | 
			TextStyleAsFontFamily new
				textStyle: (TextStyle named: textStyleName);
				familyName: textStyleName;
				yourself ].
	^ (textStyleFamilies asSortedCollection: [ :a :b | a familyName <= b familyName ]) asArray
]
