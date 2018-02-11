library("Rvision")
library("dplyr")

my_vid <- video("C:/Users/matthew.d.harris/Dropbox/R/Rvision/example_mp4/videoplayback.mp4")
old <- Sys.time()

for(i in 1:nframes(my_vid)){
  
  img <- readNext(my_vid)
  blob <- img %>%
    split() %>%
    '['(c(3,1)) %>%
    do.call(function(x, y) (x - y) > 50, .) %>%
    morph("close", iterations = 3) %>%
    simpleBlobDetector(max_area = Inf, min_area = 1000, blob_color = 255,
                       filter_by_convexity = FALSE,
                       filter_by_inertia = FALSE, min_threshold = 0)

  cat(i,"-", blob$id, ",", blob$x, ",", blob$x, ",", blob$size, "\n")
  new <- Sys.time()
  
  #### EXTRACT BLOB BOX AND FEED TO IMAGE MANIPULATION BELOW
  img32 <- resize(img, 28,28)
  img32_gray <- changeColorSpace(img32,"GRAY")
  img32_scale <- 1-(as.matrix(img32_gray)/255) # scale colors, still not 100%
  img32_array <- reticulate::array_reshape(img32_scale, c(1, 28, 28, 1))
  results <- model %>% predict(img32_array) %>%
    data.frame() %>%
    magrittr::set_colnames(seq(0,9,1))
  results$top <- as.numeric(colnames(results)[max.col(results,ties.method="first")])
  # print(results[1,])
  ####
  
  drawRectangle(img, blob$x[1] - 1 + blob$size[1]/2,
                blob$y[1] - 1 + blob$size[1]/2,
                blob$x[1] - 1 - blob$size[1]/2,
                blob$y[1] - 1 - blob$size[1]/2, thickness = 2)
  drawText(img, paste0("pred: ", format(results$top[1], digits = 2, nsmall = 0)),
           x = 30, y = 30, font_face = 'plain', font_scale = 4,
           color = "red", thickness = 3)
  
  old <- new
  
  display(img, "Live test", 1, 144*4, 176*4)
}


