"
I announce when the profiling results tree changes root
"
Class {
	#name : 'StProfilerResultsTreeRootChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'NewTools-ProfilerUI-Announcements',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
StProfilerResultsTreeRootChangedAnnouncement >> item [

	^ item
]

{ #category : 'accessing' }
StProfilerResultsTreeRootChangedAnnouncement >> item: anObject [

	item := anObject
]
