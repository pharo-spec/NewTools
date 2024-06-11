Extension { #name : 'RBClassEnvironment' }

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> addPackage: aPackage [
	^ self
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> asScopeNode [

	^ ScopeClassNode on: self
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> definedClassesDo: aBlock [ 
	^ self classesDo: aBlock
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> fullPackages [
	^ Set new
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> removePackage: aSymbol [
	^ self
]
