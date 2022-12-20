library(dplyr)

token <- "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"
auth <- sprintf("https://rscharf1:%s@github.com", token)
cat(auth, file = "~/.git-credentials", append = FALSE)

experiments <- list.dirs(path = "htmls")
experiments <- experiments[experiments!="htmls"]
experiments <- rev(experiments)

system(sprintf("cp index_base.html index.html"))

a <- lapply(seq_along(experiments), function(x) {
	exp_name <- basename(experiments[x])

	system(sprintf("sed -i 's/<p>Links<\\/p>/<p>Links<\\/p>\\n\\<h3>%s<\\/h3>/g' index.html", exp_name))

	files <- list.files(path = experiments[x], pattern = ".html", full.names = TRUE)
	files <- gsub("/", "\\\\/", files)
	files <- rev(files)

	b <- lapply(seq_along(files), function(y) {
		path <- files[y]
		name <- basename(tools::file_path_sans_ext(files[y]))
		name <- gsub("_S[0-9][0-9]_.*", "", name)

		system(sprintf("sed -i 's/<h3>%s<\\/h3>/<h3>%s<\\/h3>\\n\\<a href=%s>%s<\\/a>\\n<br>/g' index.html", exp_name, exp_name, path, name))

	})

})

system(sprintf("sed -i 's/<p>Links<\\/p>//g' index.html"))

system(sprintf("git add -A"))
system(sprintf("git commit -m 'update'"))
system(sprintf("git push"))
