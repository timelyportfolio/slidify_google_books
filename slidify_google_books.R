require(XML)

#manual but sure there is an automated way to accomplish
#the text pages go 5 at a time so start at 1 and increment by 5
pages <- seq(1,66,5)

rmdFile <- file("index.Rmd",open="w")

writeLines(
'---
title: Developing financial skill (Google eBook)
author:  Enoch Burton Gowin
---
'
,con = rmdFile
)

for( pageNum in pages ){
  url=sprintf(
    "http://books.google.com/books?id=DHARAQAAMAAJ&pg=PA%f&output=text"
    ,pageNum
  )
  
  doc <- htmlParse(url)
  
  img <- getNodeSet(doc, '//img')
  
  imgLinks <- sapply(img, function(el) {
    xmlGetAttr(el,"src")
  })
  
  if(pageNum == 1){
    imgLinks <- imgLinks[-c(1,2,4)]
  } else imgLinks <- imgLinks[-(1:4)]  #minus the cover image
  
  if(length(imgLinks)) {

    writeLines(
      sapply(
        imgLinks
        ,function(x){
          sprintf(
'<a href="%s"><img src="%s"></img></a>

---
'
,gsub(
  x=gsub(x=x,pattern="&amp",replacement="&")
  ,pattern = "(.*)(&output=text)(.*)(&img=.*)"
  ,replacement= "\\1\\3"
)
,gsub(x=x,pattern="&amp",replacement="&")
          )
        }
      )    
  , con=rmdFile
  )
  }
}


close(rmdFile)


require(slidify)

slidify("index.Rmd")

#could fix with slidify layout change but just gsub for now
htmlFile = file("index.html",open="r+")
writeLines(
  gsub(
    x = readLines("index.html")
    , pattern = "(<p>)(<a*.<img.*</a>)(</p>)"
    , replacement = "\\2"
  )
  ,con = htmlFile
)
close(htmlFile)
