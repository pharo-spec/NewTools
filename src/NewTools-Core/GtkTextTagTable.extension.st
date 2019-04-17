Extension { #name : #GtkTextTagTable }

{ #category : #'*NewTools-Core' }
GtkTextTagTable classSide >> newForCode [
	| table |
	
	table := self new.
	(SHRBTextStyler initialTextAttributesForPixelHeight: 1) 
		keysAndValuesDo: [ :aName :attributes | | tag |
			tag := GtkTextTag newName: aName asString.
			attributes do: [ :each | each acceptTag: tag ].
			table add: tag ].
	^ table
]
