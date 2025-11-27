Extension { #name : 'String' }

{ #category : '*NewTools-Epicea' }
String >> asInstanceSideBehaviorName [

	^ (self splitOn: Character space) first
]
