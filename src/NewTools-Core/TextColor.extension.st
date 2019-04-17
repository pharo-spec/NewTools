Extension { #name : #TextColor }

{ #category : #'*NewTools-Core' }
TextColor >> acceptTag: aTag [

	aTag foreground: self color
]
