Class {
	#name : #StSpotterStyleContributor,
	#superclass : #StPharoStyleContributor,
	#category : #'NewTools-Morphic-Spotter'
}

{ #category : #styles }
StSpotterStyleContributor >> styleSheetContribution [
	
	^ SpStyle newApplication 
		addClass: 'presenter' with: [ :presenter |	presenter 
			addClass: 'stSpotter' with: [ :spotter | spotter 
				addPropertyDrawWith: [ :draw | draw color: Color transparent ] ];
			addClass: 'stSpotterLink' with: [ :spotter | spotter 
				addPropertyGeometryWith: [ :geometry | geometry height: 22; vResizing: false ] ] ]; 
		addClass: 'componentList' with: [ :componentList | componentList 
			addClass: 'stSpotterList' with: [ :spotter | spotter 
				addPropertyDrawWith: [ :draw | draw color: Color transparent ] ] ];
		addClass: 'searchInputField' with: [ :searchInputField | searchInputField 
			addClass: 'stSpotterSearch' with: [ :spotter | spotter
				addPropertyDrawWith: [ :draw | draw color: Color transparent ];
				addPropertyGeometryWith: [ :geometry | geometry minHeight: 30; vResizing: false ];
				addPropertyFontWith: [ :font | font size: 12 ] ] ];
		addClass: 'text' with: [ :text | text 
			addClass: 'stSpotterPreview' with: [ :spotter | spotter
				addPropertyDrawWith: [ :draw | draw color: Color transparent ] ] ];
		addClass: 'code' with: [ :text | text 
			addClass: 'stSpotterPreview' with: [ :spotter | spotter
				addPropertyDrawWith: [ :draw | draw color: Color transparent ] ] ];
		yourself
]
