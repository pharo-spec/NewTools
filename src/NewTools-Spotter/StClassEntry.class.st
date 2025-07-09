"
I wrap a Class or Trait entry, to modify its behavior if required for the class
"
Class {
	#name : 'StClassEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Spotter-Entries',
	#package : 'NewTools-Spotter',
	#tag : 'Entries'
}

{ #category : 'accessing' }
StClassEntry >> accept: aSpotter [

	aSpotter visitClassEntry: self
]

{ #category : 'converting' }
StClassEntry >> asHistoryEntry [ 

	^ StHistoryClassEntry new: self
]

{ #category : 'converting' }
StClassEntry >> asString [

	^ content name
]

{ #category : 'accessing' }
StClassEntry >> categoryLabel [

	^ 'class'
]

{ #category : 'evaluating' }
StClassEntry >> doEvaluate [

	content browse
]

{ #category : 'accessing' }
StClassEntry >> iconName [

	^ content systemIconName
]
