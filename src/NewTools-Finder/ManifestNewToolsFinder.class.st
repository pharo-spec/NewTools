"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestNewToolsFinder',
	#superclass : 'PackageManifest',
	#category : 'NewTools-Finder-Manifest',
	#package : 'NewTools-Finder',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestNewToolsFinder class >> ruleReShouldSendSuperInitializeAsFirstMessageV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#StFinderPresenter #initialize #false)) #'2026-11-20T11:42:31.570455+01:00') )
]
