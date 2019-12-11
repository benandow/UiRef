#!/usr/bin/env python

import re

CATEGORIES = ["BOOKS_AND_REFERENCE","BUSINESS","COMICS","COMMUNICATION","EDUCATION","ENTERTAINMENT","FINANCE","GAME","HEALTH_AND_FITNESS","LIBRARIES_AND_DEMO","LIFESTYLE","MEDIA_AND_VIDEO","MEDICAL","MUSIC_AND_AUDIO","NEWS_AND_MAGAZINES","PERSONALIZATION","PHOTOGRAPHY","PRODUCTIVITY","SHOPPING","SOCIAL","SPORTS","TOOLS","TRANSPORTATION","TRAVEL_AND_LOCAL","WEATHER"]

for c in CATEGORIES:
	with open("%s/%s_EMPTY_REMOVED.csv" % (c,c,),"w") as output_file:
		for line in open("%s/%s.csv" % (c,c,),"r"):
			line = re.sub(r",$","",line.strip())
			if len(line.split(",")) > 1:
				output_file.write("%s\n" % (line,))

