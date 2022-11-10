library(dplyr)

files <- list.files(path = "yeast", pattern = ".html", full.names = TRUE)
files <- files[!grepl("index.html", files)]
files <- gsub("/", "\\\\/", files)
files <- rev(files)

lapply(seq_along(files), function(x) {
	path <- files[x]
	name <- basename(tools::file_path_sans_ext(files[x]))
	name <- gsub("_S[0-9][0-9]_.*", "", name)

	system(sprintf("sed -i 's/<p>Links<\\/p>/<p>Links<\\/p>\\n\\<a href=%s>%s<\\/a>/g' index_base.html", path, name))

})

system(sprintf("git add -A"))
system(sprintf("git commit -m 'update'"))
system(sprintf("git push"))