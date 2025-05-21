"
I am a null strategy that does nothing by default, i just return the original window
"
Class {
	#name : 'CavNullStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'NewTools-Window-Profiles-Model',
	#package : 'NewTools-Window-Profiles',
	#tag : 'Model'
}

{ #category : 'accessing' }
CavNullStrategy class >> title [

	^ 'Not Changing Strategy'
]

{ #category : 'positioning' }
CavNullStrategy >> placePresenter: aPresenter [

	aPresenter extent: placeHolder extent.

	aPresenter position: placeHolder position
]
